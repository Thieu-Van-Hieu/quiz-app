import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/quiz_search_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_notifier.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  Stream<List<Quiz>> build(QuizSearchParams params) {
    // Luôn watch repo để khi repo thay đổi (put/delete) stream sẽ tự phát lại
    return ref.watch(quizRepositoryProvider).watchQuizzes(params);
  }

  // --- HÀM GET THEO ID ---
  Future<Quiz?> getQuiz(int id) async {
    final repo = ref.read(quizRepositoryProvider);
    return await repo.getQuizById(id);
  }

  // --- HÀM SAVE VỚI FULL VALIDATE ---
  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    final trimmedName = quiz.name.trim();

    // 1. Validate dữ liệu đầu vào
    if (trimmedName.isEmpty) {
      throw ValidationException('Tên bộ đề không được để trống.');
    }
    if (trimmedName.length < 3) {
      throw ValidationException('Tên bộ đề phải có ít nhất 3 ký tự.');
    }

    final repo = ref.read(quizRepositoryProvider);

    // 2. Validate nghiệp vụ (Check trùng tên trong môn học)
    final existingQuiz = await repo.getQuizBySubjectIdAndName(
      subjectId,
      trimmedName,
    );

    if (existingQuiz != null && existingQuiz.id != quiz.id) {
      throw EntityAlreadyExistsException(
        'Bộ đề "$trimmedName" đã tồn tại trong môn học này.',
      );
    }

    // 3. Thực thi lưu dữ liệu
    quiz.name = trimmedName; // Cập nhật tên đã được trim
    await repo.saveQuiz(subjectId, quiz);
  }

  Future<void> deleteQuiz(int id) async {
    final repo = ref.read(quizRepositoryProvider);
    await repo.deleteQuiz(id);
  }
}

// --- PROVIDER BỔ TRỢ ĐỂ TÍNH TỔNG SỐ TRANG ---
// Provider này tách biệt để tránh việc UI phải re-build cả danh sách chỉ để cập nhật số trang
@riverpod
Stream<int> quizTotalPages(Ref ref, QuizSearchParams params) {
  return ref.watch(quizRepositoryProvider).watchTotalPages(params);
}

@riverpod
Stream<Quiz?> watchQuiz(Ref ref, int id) {
  return ref.watch(quizRepositoryProvider).watchQuiz(id);
}
