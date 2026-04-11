import 'package:frontend/features/library/data/answer_repository.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'answer_notifier.g.dart';

@riverpod
class AnswerNotifier extends _$AnswerNotifier {
  @override
  Stream<List<Answer>> build(int questionId) {
    final repo = ref.watch(answerRepositoryProvider);
    return repo.watchAnswersByQuestion(questionId);
  }

  void addAnswer(int questionId, Answer answer) async {
    final repo = ref.read(answerRepositoryProvider);
    await repo.saveAnswer(questionId, answer);
  }

  void updateAnswer(int answerId, Answer answer) async {
    final repo = ref.read(answerRepositoryProvider);
    answer.id = answerId; // Đảm bảo ID được gán đúng để update
    await repo.saveAnswer(answer.question.target!.id, answer);
  }

  void updateAnswers(int questionId, List<Answer> answers) async {}

  void deleteAnswer(int answerId) async {
    final repo = ref.read(answerRepositoryProvider);
    await repo.deleteAnswer(answerId);
  }

  void deleteAnswersByQuestion(int questionId) async {
    final repo = ref.read(answerRepositoryProvider);
    await repo.deleteAnswersByQuestion(questionId);
  }
}
