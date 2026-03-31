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

  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    final subject = await _isar.subjects.get(subjectId);
    if (subject == null) {
      throw Exception('Subject with id $subjectId not found');
    }
    quiz.subject.value = subject;
    await _isar.writeTxn(() async {
      await _isar.quizzes.put(quiz);
    });
  }

  Future<void> deleteQuiz(int id) async {
    await _isar.writeTxn(() async {
      await _isar.quizzes.delete(id);
    });
  }
}
