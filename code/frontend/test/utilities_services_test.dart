import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';
import 'package:frontend/features/utilities/services/quiz_analyzer.dart';
import 'package:frontend/features/utilities/services/quiz_merger.dart';
import 'package:frontend/features/utilities/services/quiz_splitter.dart';

/// Tạo câu hỏi; [correct] là vị trí (0-based) các đáp án đúng
Question q(String content, List<String> answers, List<int> correct) {
  final question = Question(content: content);
  for (final (i, a) in answers.indexed) {
    question.answers.add(
      Answer(content: a, isCorrect: correct.contains(i), indexOrder: i),
    );
  }
  return question;
}

void main() {
  group('QuizAnalyzer', () {
    final questions = [
      q('Câu 1', ['Ngắn', 'Đáp án dài nhất ở đây', 'Vừa vừa'], [1]),
      q('Câu 2', ['Đúng là dài hơn hẳn', 'Sai', 'Cũng sai'], [0]),
      q('Câu 3', ['A', 'B', 'C'], [0, 2]),
      q('Câu 4', ['Thực tại khách quan', 'Ý thức'], [1]),
      q('Câu 5', ['Vật chất', 'Ý thức'], [0]),
    ];
    final result = QuizAnalyzer.analyze(questions);

    test('Đếm số câu 1 / nhiều đáp án và phân bổ vị trí', () {
      expect(result.singleCorrect, 4);
      expect(result.multiCorrect, 1);
      expect(result.correctCountDistribution, {1: 4, 2: 1});
      expect(result.positionDistribution, {'A': 2, 'B': 2});
    });

    test('Tỉ lệ đáp án dài nhất là đáp án đúng', () {
      // Câu 1, 2, 5: dài nhất là đáp án đúng; câu 4: dài nhất là đáp án sai
      expect(result.longestIsCorrect.applicable, 4);
      expect(result.longestIsCorrect.hits, 3);
    });

    test('Đáp án đúng là đáp án sai ở câu khác', () {
      final group = result.correctUsedAsWrong.single;
      expect(group.key, 'Ý thức');
      expect(group.questions.map((e) => e.content), ['Câu 4']);
    });

    test('Cụm từ chỉ có trong đáp án đúng (giữ chữ có dấu)', () {
      final phrases = QuizAnalyzer.uniqueCorrectPhrases([
        q('1', ['Chủ nghĩa duy vật biện chứng', 'Sai'], [0]),
        q('2', ['Phép duy vật biện chứng', 'Chủ nghĩa duy tâm'], [0]),
      ]);
      expect(phrases.map((p) => p.phrase), contains('duy vật biện'));
      expect(phrases.map((p) => p.phrase), isNot(contains('chủ nghĩa')));
    });
  });

  group('QuizSplitter', () {
    final questions = [
      for (var i = 1; i <= 5; i++) q('Câu $i', ['X'], [0])..id = i,
    ];

    test('Tách theo khoảng câu (tính cả 2 đầu, tự giới hạn)', () {
      expect(QuizSplitter.byRange(questions, 2, 4).map((e) => e.content), [
        'Câu 2',
        'Câu 3',
        'Câu 4',
      ]);
      expect(QuizSplitter.byRange(questions, 4, 99).length, 2);
    });

    test('Tách từ session: chỉ câu sai, bỏ câu đã xoá', () {
      final quiz = Quiz(name: 'Q');
      for (final question in questions) {
        question.quiz.target = quiz;
      }
      final session = LearningSession(learningMode: 'study');
      LearningSessionDetail detail(Question? question, bool? passed) {
        final d = LearningSessionDetail(isChecked: true)..isPassed = passed;
        d.question.target = question;
        return d;
      }

      session.learningSessionDetails.addAll([
        detail(questions[0], false),
        detail(questions[1], true),
        detail(null, false), // Câu đã bị xoá
        detail(questions[2], null),
      ]);

      expect(
        QuizSplitter.fromSession(
          session,
          SessionQuestionFilter.wrong,
        ).map((e) => e.content),
        ['Câu 1'],
      );
      expect(
        QuizSplitter.fromSession(
          session,
          SessionQuestionFilter.notPassed,
        ).map((e) => e.content),
        ['Câu 1', 'Câu 3'],
      );
    });

    test('Quiz mới là bản sao, không đụng câu gốc', () {
      final original = q('Gốc', ['B', 'A'], [0])..id = 7;
      final quiz = QuizSplitter.buildQuiz('Mới', [original]);
      final copy = quiz.questions.single;
      expect(copy.id, 0);
      expect(identical(copy, original), isFalse);
      expect(copy.answers.map((a) => a.content), ['B', 'A']);
      expect(original.quiz.target, isNull);
    });
  });

  group('QuizMerger', () {
    final a1 = q('Thủ đô?', ['Hà Nội', 'Huế'], [0]);
    final a2 = q('Ý thức là gì?', ['X'], [0]);
    final b1 = q('thủ đô?', ['Huế', 'Hà Nội'], [1]); // Trùng hoàn toàn a1
    final b2 = q('Ý thức là gì? (bản mới)', ['X'], [0]); // Chứa a2 nhưng khác
    final b3 = q(
      'Thủ đô?',
      ['Hà Nội', 'Huế'],
      [1],
    ); // Trùng nội dung, khác đáp án

    test('Trùng cả câu + đáp án, giữ câu trước', () {
      final r = QuizMerger.merge([
        [a1, a2],
        [b1, b2, b3],
      ]);
      expect(r.questions, [a1, a2, b2, b3]);
      expect(r.duplicateCount, 1);
      expect(r.inputCount, 5);
    });

    test('Chỉ trùng nội dung, thay bằng câu sau', () {
      final r = QuizMerger.merge(
        [
          [a1, a2],
          [b1, b2, b3],
        ],
        criteria: MergeDuplicateCriteria.content,
        action: MergeDuplicateAction.replace,
      );
      expect(r.questions, [b3, a2, b2]);
      expect(r.duplicateCount, 2);
    });
  });

  test('DuplicateReport phân biệt trùng hoàn toàn và chỉ trùng câu hỏi', () {
    final a = q('Thủ đô?', ['Hà Nội', 'Huế'], [0]);
    final b = q('thủ đô?', ['Huế', 'Hà Nội'], [1]);
    final c = q('Thủ đô?', ['Hà Nội', 'Huế'], [1]);
    final report = QuizDeduplicator.findDuplicateGroups([a, b, c]);
    expect(report.fullGroups, [
      [a, b],
    ]);
    expect(report.contentOnlyGroups, [
      [a, b, c],
    ]);
    expect(report.removableCount, 1);
  });
}
