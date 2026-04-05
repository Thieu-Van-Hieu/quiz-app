import 'package:frontend/features/library/data/question_repository.dart';
import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/question.dart';
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

  void addQuestion(Question question) {
    final currentList = state.value ?? [];
    state = AsyncValue.data([...currentList, question]);
  }

  void updateQuestion(int index, Question question) {
    final currentList = state.value;
    if (currentList != null && index >= 0 && index < currentList.length) {
      final newList = List<Question>.from(currentList);
      newList[index] = question;
      state = AsyncValue.data(newList);
    }
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

      // Gọi repository lưu xuống Isar
      await quizRepo.updateQuizQuestions(quizId, questionsToSave);

      // Sau khi lưu xong, ép buộc load lại dữ liệu từ DB để lấy ID chính xác (tránh lỗi sync)
      final repo = ref.read(questionRepositoryProvider);
      final freshData = await repo.getQuestionsByQuiz(quizId);

      state = AsyncValue.data(freshData);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
