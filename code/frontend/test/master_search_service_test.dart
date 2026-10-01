import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/search/services/master_search_service.dart';

void main() {
  final mln = Subject(name: 'Triết học', code: 'MLN111')..id = 1;
  final prm = Subject(name: 'Flutter', code: 'PRM393')..id = 2;
  final quizMln = Quiz(name: 'MLN FE')..id = 10;
  quizMln.subject.target = mln;
  final quizPrm = Quiz(name: 'Flutter MCQ')..id = 20;
  quizPrm.subject.target = prm;

  Question q(
    int id,
    Quiz quiz,
    String content,
    List<Answer> answers, {
    String explanation = '',
  }) {
    final question = Question(content: content, explanation: explanation)
      ..id = id;
    question.quiz.target = quiz;
    question.answers.addAll(answers);
    return question;
  }

  final corpus = SearchCorpus(
    questions: [
      q(2, quizMln, 'Vật chất là gì?', [
        Answer(content: 'Thực tại khách quan', isCorrect: true),
        Answer(content: 'Ý thức', isCorrect: false),
      ]),
      q(1, quizMln, 'Ý thức có nguồn gốc từ đâu?', [
        Answer(content: 'Bộ óc người', isCorrect: true),
        Answer(content: 'Vật chất', isCorrect: false),
      ]),
      q(3, quizPrm, 'Widget là gì?', [
        Answer(content: 'Thành phần UI', isCorrect: true),
      ], explanation: 'Mọi thứ trong Flutter là widget'),
    ],
    quizzes: [quizMln, quizPrm],
    subjects: [mln, prm],
  );

  List<int> ids(MasterSearchResult r) =>
      r.questions.map((h) => h.question.id).toList();

  test('Tìm cả câu hỏi và đáp án mặc định', () {
    final r = MasterSearchService.search(
      corpus,
      TextMatcher('vật chất'),
      const MasterSearchScope(),
    );
    expect(ids(r), [2, 1]);
  });

  test('Chỉ đáp án đúng', () {
    final r = MasterSearchService.search(
      corpus,
      TextMatcher('vật chất'),
      const MasterSearchScope(inContent: false, onlyCorrectAnswers: true),
    );
    expect(ids(r), isEmpty);
  });

  test('Tìm trong giải thích', () {
    final r = MasterSearchService.search(
      corpus,
      TextMatcher('mọi thứ'),
      const MasterSearchScope(inExplanation: true),
    );
    expect(ids(r), [3]);
  });

  test('Lọc theo môn học, trả về cả bộ đề và môn khớp tên', () {
    final r = MasterSearchService.search(
      corpus,
      TextMatcher('flutter'),
      const MasterSearchScope(inExplanation: true, subjectId: 2),
    );
    expect(ids(r), [3]);
    expect(r.quizzes, [quizPrm]);
    expect(r.subjects, [prm]);
  });

  test('Số thứ tự câu trong quiz tính theo id', () {
    expect(corpus.questionNumbers, {1: 1, 2: 2, 3: 1});
  });
}
