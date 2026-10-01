import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

/// Lọc câu hỏi trong 1 session
enum SessionQuestionFilter {
  wrong("Câu làm sai"),
  notPassed("Câu chưa đúng (sai + chưa làm)"),
  passed("Câu làm đúng"),
  all("Tất cả câu trong session");

  final String label;

  const SessionQuestionFilter(this.label);
}

/// Tách quiz (port từ utilities/split.py)
class QuizSplitter {
  /// Câu từ [from] đến [to] (đánh số từ 1, tính cả 2 đầu)
  static List<Question> byRange(List<Question> questions, int from, int to) {
    final start = (from - 1).clamp(0, questions.length);
    final end = to.clamp(start, questions.length);
    return questions.sublist(start, end);
  }

  /// Câu hỏi trong session theo bộ lọc, giữ thứ tự xuất hiện trong session.
  /// Bỏ qua câu đã bị xoá hoặc bị gỡ khỏi quiz.
  static List<Question> fromSession(
    LearningSession session,
    SessionQuestionFilter filter,
  ) {
    final seen = <int>{};
    return [
      for (final detail in session.learningSessionDetails)
        if (switch (filter) {
          SessionQuestionFilter.wrong => detail.isPassed == false,
          SessionQuestionFilter.notPassed => detail.isPassed != true,
          SessionQuestionFilter.passed => detail.isPassed == true,
          SessionQuestionFilter.all => true,
        })
          if (detail.question.target case final q?)
            if (q.quiz.target != null && seen.add(q.id)) q,
    ];
  }

  /// Bản sao câu hỏi (id = 0) để lưu vào quiz mới mà không ảnh hưởng quiz gốc
  static Question cloneQuestion(Question source) {
    final copy = Question(
      content: source.content,
      explanation: source.explanation,
    );
    final answers = source.answers.toList()
      ..sort((a, b) => a.indexOrder.compareTo(b.indexOrder));
    for (final (i, a) in answers.indexed) {
      copy.answers.add(
        Answer(content: a.content, isCorrect: a.isCorrect, indexOrder: i),
      );
    }
    copy.syncAnswers();
    return copy;
  }

  /// Tạo quiz mới (chưa lưu) từ danh sách câu hỏi
  static Quiz buildQuiz(String name, Iterable<Question> questions) {
    final quiz = Quiz(name: name);
    for (final q in questions) {
      final copy = cloneQuestion(q);
      copy.quiz.target = quiz;
      quiz.questions.add(copy);
    }
    return quiz;
  }
}
