import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';

Question q(String content, Map<String, bool> answers) {
  final question = Question(content: content);
  question.answers.addAll(
    answers.entries.map((e) => Answer(content: e.key, isCorrect: e.value)),
  );
  return question;
}

void main() {
  test('Trùng khi khác hoa thường, khoảng trắng và thứ tự đáp án', () {
    final a = q('Thủ đô Việt Nam?', {'Hà Nội': true, 'Huế': false});
    final b = q('  thủ đô  việt nam? ', {'Huế': false, 'hà nội': true});
    expect(QuizDeduplicator.findDuplicates([a, b]), [b]);
  });

  test('Không trùng khi đáp án đúng khác nhau', () {
    final a = q('Câu hỏi?', {'X': true, 'Y': false});
    final b = q('Câu hỏi?', {'X': false, 'Y': true});
    expect(QuizDeduplicator.findDuplicates([a, b]), isEmpty);
  });

  test('Bỏ qua câu nháp rỗng', () {
    final a = q('', {'': true});
    final b = q('', {'': true});
    expect(QuizDeduplicator.findDuplicates([a, b]), isEmpty);
  });

  test('removeDuplicates giữ câu xuất hiện đầu tiên', () {
    final a = q('Câu 1', {'A': true});
    final b = q('Câu 2', {'B': true});
    final c = q('Câu 1', {'A': true});
    expect(QuizDeduplicator.removeDuplicates([a, b, c]), [a, b]);
  });
}
