import 'package:frontend/core/extensions/condition_extension.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/subject_search_params.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subject_repository.g.dart';

@riverpod
SubjectRepository subjectRepository(Ref ref) {
  return SubjectRepository();
}

class SubjectRepository {
  final _db = ObjectBoxService.instance;
  final _subjectBox = ObjectBoxService.instance.get<Subject>();

  /// 1. Theo dõi toàn bộ danh sách môn học (Real-time)
  Stream<List<Subject>> watchAllSubjects() {
    // .query() không tham số tương đương với lấy tất cả
    return _subjectBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Condition<Subject>? getSearchParamsCondition(SubjectSearchParams params) {
    Condition<Subject>? condition;

    // Xây dựng query theo logic mong muốn
    condition = condition
        .safeOr(
          params.keyword,
          (v) => Subject_.name.contains(v, caseSensitive: false),
        )
        .safeOr(
          params.keyword,
          (v) => Subject_.code.contains(v, caseSensitive: false),
        );

    return condition;
  }

  Stream<List<Subject>> watchSubjects(SubjectSearchParams params) {
    return _subjectBox
        .query(getSearchParamsCondition(params))
        .watch(triggerImmediately: true)
        .map(((query) {
          query.offset = params.page * params.size;
          query.limit = params.size;

          // Lúc này find() sẽ trả về đúng số lượng đã phân trang
          return query.find();
        }));
  }

  Stream<int> watchTotalPages(SubjectSearchParams params) {
    return _subjectBox
        .query(getSearchParamsCondition(params))
        .watch(triggerImmediately: true)
        .map((query) {
          // 3. Đếm tổng số bản ghi khớp điều kiện
          final totalItems = query.count();
          if (totalItems == 0) return 1;

          // 4. Tính toán số trang: ceil(totalItems / size)
          return (totalItems / params.size).ceil();
        });
  }

  /// 2. Lấy môn học theo ID
  Future<Subject?> getSubjectById(int id) {
    return _subjectBox.getAsync(id);
  }

  /// 3. Tìm môn học theo mã code (Sử dụng Index đã khai báo trong Model)
  Future<Subject?> getSubjectByCode(String code) async {
    final query = _subjectBox.query(Subject_.code.equals(code)).build();
    final result = await query.findFirstAsync();
    query.close();
    return result;
  }

  /// 4. Lưu hoặc cập nhật môn học
  Future<void> saveSubject(Subject subject) async {
    await _subjectBox.putAsync(subject);
  }

  /// 5. Xóa môn học và các Quiz liên quan (Cascading Delete)
  Future<void> deleteSubject(int id) async {
    // Thực hiện trong Transaction để đảm bảo:
    // Nếu xóa Quiz lỗi thì Subject cũng không bị xóa mất xác
    await _db.store.runInTransactionAsync(TxMode.write, (
      Store store,
      List<dynamic> params,
    ) {
      final sId = params[0] as int;
      final internalSubjectBox = store.box<Subject>();
      final internalQuizBox = store.box<Quiz>();

      // 1. Tìm và xóa toàn bộ Quiz thuộc Subject này trước
      final query = internalQuizBox.query(Quiz_.subject.equals(sId)).build();
      query.remove();
      query.close();

      // 2. Xóa chính Subject đó
      final success = internalSubjectBox.remove(sId);
      if (!success) {
        throw Exception('Môn học không tồn tại hoặc đã bị xóa.');
      }
    }, [id]);
  }
}
