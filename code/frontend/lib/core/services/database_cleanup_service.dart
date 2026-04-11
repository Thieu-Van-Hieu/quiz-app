import 'package:flutter/cupertino.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart'; // Thêm import model của phen
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/objectbox.g.dart';

class DatabaseCleanupService {
  static Future<void> runFullCleanup() async {
    final store = ObjectBoxService.instance.store;

    await store.runInTransactionAsync<void, void>(TxMode.write, (store, _) {
      // 1. Dọn Detail mồ côi trước (Vì nó là thằng trung gian nhiều nhất)
      final detailBox = store.box<LearningSessionDetail>();
      final orphanDetails = detailBox
          .query(
            LearningSessionDetail_.question
                .equals(0)
                .or(LearningSessionDetail_.learningSession.equals(0)),
          )
          .build();
      detailBox.removeMany(orphanDetails.findIds());
      orphanDetails.close();

      // 2. Dọn Answer mồ côi (Answer không thuộc Question nào)
      final answerBox = store.box<Answer>();
      final orphanAnswers = answerBox.query(Answer_.question.equals(0)).build();
      answerBox.removeMany(orphanAnswers.findIds());
      orphanAnswers.close();

      // 3. Dọn Question mồ côi (Question không thuộc Quiz nào)
      final questionBox = store.box<Question>();
      final orphanQuestions = questionBox
          .query(Question_.quiz.equals(0))
          .build();
      questionBox.removeMany(orphanQuestions.findIds());
      orphanQuestions.close();

      // 4. (Bonus) Dọn Quiz mồ côi nếu Subject bị xóa
      final quizBox = store.box<Quiz>();
      final orphanQuizzes = quizBox.query(Quiz_.subject.equals(0)).build();
      quizBox.removeMany(orphanQuizzes.findIds());
      orphanQuizzes.close();

      debugPrint('🚀 Database Cleanup: All orphans removed!');
    }, null);
  }
}
