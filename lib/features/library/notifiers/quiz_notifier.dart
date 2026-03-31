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

  Future<void> saveSubject(int subjectId, Quiz quiz) async {
    final repo = ref.read(quizRepositoryProvider);
    await repo.saveQuiz(subjectId, quiz);
  }

  Future<void> deleteQuiz(int id) async {
    final repo = ref.read(quizRepositoryProvider);
    await repo.deleteQuiz(id);
  }
}
