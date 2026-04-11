import 'package:frontend/core/exceptions/app_exception.dart'; // Đảm bảo đã có ValidationException
import 'package:frontend/features/library/data/subject_repository.dart';
import 'package:frontend/features/library/models/search_params/subject_search_params.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subject_notifier.g.dart';

@riverpod
class SubjectNotifier extends _$SubjectNotifier {
  @override
  Stream<List<Subject>> build(SubjectSearchParams params) {
    final repo = ref.watch(subjectRepositoryProvider);
    return repo.watchSubjects(params);
  }

  // --- HÀM GET THEO ID ---
  Future<Subject?> getSubject(int id) async {
    final repo = ref.read(subjectRepositoryProvider);
    return await repo.getSubjectById(id);
  }

  // --- HÀM SAVE VỚI BUSINESS LOGIC ---
  Future<void> saveSubject(Subject subject) async {
    // 1. Clean data & Basic Validation
    final trimmedCode = subject.code
        .trim()
        .toUpperCase(); // Mã môn thường viết hoa
    final trimmedName = subject.name.trim();

    if (trimmedCode.isEmpty) {
      throw ValidationException('Mã môn học không được để trống.');
    }
    if (trimmedName.isEmpty) {
      throw ValidationException('Tên môn học không được để trống.');
    }

    final repo = ref.read(subjectRepositoryProvider);

    // 2. Validate nghiệp vụ: Check trùng Mã môn (Code là Unique)
    // Giả sử repo của phen có hàm findByCode
    final existingByCode = await repo.getSubjectByCode(trimmedCode);
    if (existingByCode != null && existingByCode.id != subject.id) {
      throw EntityAlreadyExistsException(
        'Mã môn học "$trimmedCode" đã tồn tại trong hệ thống.',
      );
    }

    // 3. Thực thi lưu dữ liệu
    subject
      ..code = trimmedCode
      ..name = trimmedName;

    await repo.saveSubject(subject);
  }

  // --- HÀM DELETE ---
  Future<void> deleteSubject(int id) async {
    final repo = ref.read(subjectRepositoryProvider);

    // Logic SE: Có thể check xem môn học này có đang chứa Quiz nào không trước khi xóa
    // Nếu có thì ném lỗi không cho xóa để đảm bảo Referential Integrity (Ràng buộc tham chiếu)

    await repo.deleteSubject(id);
  }
}

@riverpod
Stream<int> subjectTotalPages(Ref ref, SubjectSearchParams params) {
  return ref.watch(subjectRepositoryProvider).watchTotalPages(params);
}
