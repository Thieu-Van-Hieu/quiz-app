import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  Stream<List<Quiz>> build(int subjectId) {
    final repo = ref.watch(quizRepositoryProvider);
    return repo.watchAllQuizzes(subjectId);
  }

  // --- HÀM GET THEO ID ---
  Future<Quiz?> getQuiz(int id) async {
    final repo = ref.read(quizRepositoryProvider);
    return await repo.getQuizById(id);
  }

  // --- HÀM SAVE VỚI FULL VALIDATE ---
  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    // 1. Validate dữ liệu đầu vào (Input Validation)
    final trimmedName = quiz.name.trim();
    if (trimmedName.isEmpty) {
      throw ValidationException('Tên bộ đề không được để trống.');
    }

    if (trimmedName.length < 3) {
      throw ValidationException('Tên bộ đề phải có ít nhất 3 ký tự.');
    }

    final repo = ref.read(quizRepositoryProvider);

    // 2. Validate nghiệp vụ (Business Logic Validation)
    // Check trùng tên trong cùng một môn học
    final existingQuiz = await repo.getQuizBySubjectIdAndName(
      subjectId,
      trimmedName,
    );

    // Nếu tìm thấy quiz trùng tên VÀ (đây là tạo mới HOẶC đổi tên sang tên của quiz khác)
    if (existingQuiz != null && existingQuiz.id != quiz.id) {
      throw EntityAlreadyExistsException(
        'Bộ đề "$trimmedName" đã tồn tại trong môn học này.',
      );
    }

    // 3. Thực thi lưu dữ liệu
    // Cập nhật lại tên đã trim để DB sạch đẹp
    quiz.name = trimmedName;
    await repo.saveQuiz(subjectId, quiz);
  }

  Future<void> deleteQuiz(int id) async {
    // Có thể check thêm ở đây nếu cần, ví dụ: không cho xóa nếu bộ đề đang có câu hỏi
    final repo = ref.read(quizRepositoryProvider);
    await repo.deleteQuiz(id);
  }
}
