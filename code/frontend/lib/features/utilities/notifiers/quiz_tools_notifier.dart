import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/features/library/data/question_repository.dart';
import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';
import 'package:frontend/features/utilities/services/quiz_splitter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_tools_notifier.g.dart';

// keepAlive để không bị dispose giữa các lệnh await
@Riverpod(keepAlive: true)
class QuizToolsNotifier extends _$QuizToolsNotifier {
  @override
  void build() {}

  /// Tạo bộ đề mới từ bản sao các câu hỏi (dùng cho Tách / Gộp quiz)
  Future<Quiz> createQuiz({
    required int subjectId,
    required String name,
    required List<Question> questions,
  }) async {
    if (questions.isEmpty) {
      throw ValidationException('Không có câu hỏi nào để tạo bộ đề.');
    }
    final quiz = QuizSplitter.buildQuiz(name, questions);
    await validateAndSaveQuiz(
      ref.read(quizRepositoryProvider),
      subjectId,
      quiz,
    );
    return quiz;
  }

  /// Xoá các câu trùng hoàn toàn (cả câu hỏi + đáp án) trong 1 bộ đề, giữ câu đầu tiên.
  /// Trả về số câu đã xoá.
  Future<int> removeFullDuplicates(int quizId) async {
    final questions = await ref
        .read(questionRepositoryProvider)
        .getQuestionsByQuiz(quizId);
    final kept = QuizDeduplicator.removeDuplicates(questions);
    final removed = questions.length - kept.length;
    if (removed > 0) {
      await ref.read(quizRepositoryProvider).updateQuizQuestions(quizId, kept);
    }
    return removed;
  }
}
