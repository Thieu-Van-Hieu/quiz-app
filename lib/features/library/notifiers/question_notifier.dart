import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_notifier.g.dart';

@riverpod
class QuestionNotifier extends _$QuestionNotifier {
  @override
  FutureOr<List<Question>> build(int quizId) async {
    final repo = ref.watch(quizRepositoryProvider);
    final quiz = await repo.getQuizById(quizId);
    return quiz?.questions ?? [];
  }

  // --- LOGIC TRONG BỘ NHỚ (UI) ---

  void addQuestion(Question q) {
    final currentList = state.value ?? [];
    state = AsyncValue.data([...currentList, q]);
  }

  void updateQuestion(int index, Question q) {
    final currentList = List<Question>.from(state.value ?? []);
    if (index >= 0 && index < currentList.length) {
      currentList[index] = q;
      state = AsyncValue.data(currentList);
    }
  }

  void deleteQuestion(int index) {
    final currentList = List<Question>.from(state.value ?? []);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      state = AsyncValue.data(currentList);
    }
  }

  // --- LOGIC GHI XUỐNG DB (FINAL SAVE) ---

  Future<void> saveToDb() async {
    final questions = state.value ?? [];
    final repo = ref.read(quizRepositoryProvider);

    // Gọi hàm update của repo (hàm này chỉ cần put(quiz) là đủ)
    await repo.updateQuizQuestions(quizId, questions);

    // Sau khi save xong, Isar watch ở QuizNotifier sẽ tự nổ data mới
  }
}
