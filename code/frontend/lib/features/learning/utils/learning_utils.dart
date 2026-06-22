import 'dart:math';

import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/library/models/answer.dart';

class LearningUtils {
  static List<Answer> getShuffledAnswers({
    required LearningSession? session,
    required int questionId,
    required List<Answer> originalAnswers,
  }) {
    final displayAnswers = [...originalAnswers];

    if (session != null && (session.shuffleAnswers)) {
      final int seed = Object.hash(session.id, questionId);
      displayAnswers.shuffle(Random(seed));
    }

    return displayAnswers;
  }
}
