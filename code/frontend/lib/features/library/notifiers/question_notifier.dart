import 'package:frontend/features/library/data/question_repository.dart';
import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/services/quiz/quiz_convert_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_notifier.g.dart';

// Thêm keepAlive: true để dữ liệu nháp không bị mất khi Navigator.pop hoặc chuyển màn hình
@Riverpod(keepAlive: true)
class QuestionNotifier extends _$QuestionNotifier {
  @override
  FutureOr<List<Question>> build(int quizId) async {
    final repo = ref.watch(questionRepositoryProvider);
    // Lấy dữ liệu thực tế từ database khi khởi tạo
    final initialQuestions = await repo.getQuestionsByQuiz(quizId);
    return initialQuestions;
  }

  // Trong QuestionNotifier
  Future<void> importFromOcr(String editedText) async {
    final questions = QuizConverterService.convertRawOcrToQuestions(editedText);
    for (var q in questions) {
      addQuestion(q);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(questionRepositoryProvider);
      final freshData = await repo.getQuestionsByQuiz(quizId);
      state = AsyncValue.data(freshData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // --- LOGIC TRONG BỘ NHỚ (NHÁP) ---

  void updateQuestion(int index, Question updatedQuestion) {
    final currentList = state.value;
    if (currentList != null) {
      final newList = List<Question>.from(currentList);
      newList[index] = updatedQuestion; // Phải thay thế phần tử tại index
      state = AsyncValue.data(newList);
    }
  }

  void addQuestion(Question question) {
    final currentList = state.value ?? [];
    state = AsyncValue.data([...currentList, question]);
  }

  void deleteQuestion(int index) {
    final currentList = state.value;
    if (currentList != null && index >= 0 && index < currentList.length) {
      final newList = List<Question>.from(currentList);
      newList.removeAt(index);
      state = AsyncValue.data(newList);
    }
  }

  // --- LOGIC GHI XUỐNG DB ---
  Future<void> saveToDb() async {
    if (state.isLoading) return;

    final questionsToSave = state.value ?? [];
    final quizRepo = ref.read(quizRepositoryProvider);

    try {
      state = const AsyncValue.loading();

      // Đảm bảo mọi câu hỏi đều đã được gán quan hệ với Answer con
      for (var q in questionsToSave) {
        q.syncAnswers();
      }

      await quizRepo.updateQuizQuestions(quizId, questionsToSave);

      // Refresh lại dữ liệu từ DB để lấy ID mới nhất
      if (ref.mounted) {
        ref.invalidate(questionRepositoryProvider);
      }
      final repo = ref.read(questionRepositoryProvider);
      final freshData = await repo.getQuestionsByQuiz(quizId);

      state = AsyncValue.data(freshData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
