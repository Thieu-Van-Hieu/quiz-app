import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';

/// Phạm vi tìm kiếm của Master Search
class MasterSearchScope {
  final bool inContent;
  final bool inAnswers;
  final bool inExplanation;

  /// Khi tìm trong đáp án, chỉ xét các đáp án đúng
  final bool onlyCorrectAnswers;

  /// Chỉ tìm trong 1 môn học (null = tất cả)
  final int? subjectId;

  const MasterSearchScope({
    this.inContent = true,
    this.inAnswers = true,
    this.inExplanation = false,
    this.onlyCorrectAnswers = false,
    this.subjectId,
  });

  bool get hasAnyField => inContent || inAnswers || inExplanation;

  MasterSearchScope copyWith({
    bool? inContent,
    bool? inAnswers,
    bool? inExplanation,
    bool? onlyCorrectAnswers,
    int? Function()? subjectId,
  }) {
    return MasterSearchScope(
      inContent: inContent ?? this.inContent,
      inAnswers: inAnswers ?? this.inAnswers,
      inExplanation: inExplanation ?? this.inExplanation,
      onlyCorrectAnswers: onlyCorrectAnswers ?? this.onlyCorrectAnswers,
      subjectId: subjectId != null ? subjectId() : this.subjectId,
    );
  }
}

/// Toàn bộ dữ liệu để tìm kiếm, kèm số thứ tự câu hỏi trong từng quiz
class SearchCorpus {
  final List<Question> questions;
  final List<Quiz> quizzes;
  final List<Subject> subjects;

  /// questionId -> số thứ tự trong quiz (bắt đầu từ 1)
  final Map<int, int> questionNumbers;

  SearchCorpus({
    required this.questions,
    required this.quizzes,
    required this.subjects,
  }) : questionNumbers = _buildQuestionNumbers(questions);

  static Map<int, int> _buildQuestionNumbers(List<Question> questions) {
    final byQuiz = <int, List<int>>{};
    for (final q in questions) {
      final quizId = q.quiz.target?.id;
      if (quizId == null) continue;
      byQuiz.putIfAbsent(quizId, () => []).add(q.id);
    }
    return {
      for (final ids in byQuiz.values)
        for (final (i, id) in (ids..sort()).indexed) id: i + 1,
    };
  }
}

class QuestionSearchHit {
  final Question question;
  final Quiz quiz;
  final Subject? subject;
  final int number;

  QuestionSearchHit({
    required this.question,
    required this.quiz,
    required this.subject,
    required this.number,
  });
}

class MasterSearchResult {
  final List<QuestionSearchHit> questions;
  final List<Quiz> quizzes;
  final List<Subject> subjects;

  const MasterSearchResult({
    this.questions = const [],
    this.quizzes = const [],
    this.subjects = const [],
  });

  bool get isEmpty => questions.isEmpty && quizzes.isEmpty && subjects.isEmpty;
}

class MasterSearchService {
  /// Các trường văn bản của câu hỏi được tìm theo phạm vi
  static List<String> questionFields(Question q, MasterSearchScope scope) => [
    if (scope.inContent) q.content,
    if (scope.inAnswers)
      ...q.answers
          .where((a) => !scope.onlyCorrectAnswers || a.isCorrect)
          .map((a) => a.content),
    if (scope.inExplanation) q.explanation,
  ];

  static MasterSearchResult search(
    SearchCorpus corpus,
    TextMatcher matcher,
    MasterSearchScope scope,
  ) {
    if (matcher.isEmpty || matcher.error != null) {
      return const MasterSearchResult();
    }

    bool inSubject(int? subjectId) =>
        scope.subjectId == null || scope.subjectId == subjectId;

    final hits = <QuestionSearchHit>[];
    if (scope.hasAnyField) {
      for (final q in corpus.questions) {
        final quiz = q.quiz.target;
        if (quiz == null) continue; // Câu hỏi mồ côi đang chờ dọn dẹp
        if (!inSubject(quiz.subject.target?.id)) continue;
        if (!matcher.hasMatchInAny(questionFields(q, scope))) continue;

        hits.add(
          QuestionSearchHit(
            question: q,
            quiz: quiz,
            subject: quiz.subject.target,
            number: corpus.questionNumbers[q.id] ?? 0,
          ),
        );
      }
    }

    return MasterSearchResult(
      questions: hits,
      quizzes: matcher.filter(
        corpus.quizzes.where((q) => inSubject(q.subject.target?.id)),
        (q) => [q.name],
      ),
      subjects: matcher.filter(
        corpus.subjects.where((s) => inSubject(s.id)),
        (s) => [s.name, s.code],
      ),
    );
  }
}
