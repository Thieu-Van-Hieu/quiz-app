import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/services/isar_service.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'quiz_repository.g.dart';

@riverpod
QuizRepository quizRepository(QuizRepositoryRef ref) {
  return QuizRepository();
}

class QuizRepository {
  final _isar = IsarService.instance;

  Stream<List<Quiz>> watchAllQuizzes(int subjectId) {
    return _isar.quizzes
        .filter()
        .subject((subject) => subject.idEqualTo(subjectId))
        .watch(fireImmediately: true);
  }

  Future<Quiz?> getQuizById(int id) async {
    return await _isar.quizzes.get(id);
  }

  Future<Quiz?> getQuizBySubjectIdAndName(int subjectId, String name) async {
    return await _isar.quizzes
        .filter()
        .subject((subject) => subject.idEqualTo(subjectId))
        .nameEqualTo(name)
        .findFirst();
  }

  Future<void> updateQuizQuestions(int quizId, List<Question> questions) async {
    final quiz = await _isar.quizzes.get(quizId);
    if (quiz == null) {
      throw EntityNotFoundException('Quiz không tồn tại.');
    }

    quiz.questions = questions;

    await _isar.writeTxn(() async {
      // Chỉ cần put lại chính nó, Isar tự hiểu là update dựa trên ID
      await _isar.quizzes.put(quiz);
    });
  }

  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    final subject = await _isar.subjects.get(subjectId);
    if (subject == null) {
      throw EntityNotFoundException('Môn học không tồn tại.');
    }
    quiz.subject.value = subject;
    await _isar.writeTxn(() async {
      await _isar.quizzes.put(quiz);
      await quiz.subject.save(); // Lưu liên kết sau khi đã có ID của quiz
    });
  }

  Future<void> deleteQuiz(int id) async {
    await _isar.writeTxn(() async {
      await _isar.quizzes.delete(id);
    });
  }
}
