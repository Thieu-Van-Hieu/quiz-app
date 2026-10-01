import 'package:frontend/core/extensions/list_extension.dart';
import 'package:frontend/core/search/text_matcher.dart';
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

  /// Lọc theo keyword (tên hoặc mã môn) bằng TextMatcher để hỗ trợ các tuỳ chọn tìm kiếm
  List<Subject> _search(List<Subject> subjects, SubjectSearchParams params) {
    final matcher = TextMatcher(params.keyword ?? '', params.options);
    return matcher.filter(subjects, (s) => [s.name, s.code]);
  }

  Stream<List<Subject>> watchSubjects(SubjectSearchParams params) {
    return _subjectBox
        .query()
        .watch(triggerImmediately: true)
        .map(
          (query) =>
              _search(query.find(), params).paged(params.page, params.size),
        );
  }

  Stream<int> watchTotalPages(SubjectSearchParams params) {
    return _subjectBox.query().watch(triggerImmediately: true).map((query) {
      final totalItems = _search(query.find(), params).length;
      if (totalItems == 0) return 1;
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
