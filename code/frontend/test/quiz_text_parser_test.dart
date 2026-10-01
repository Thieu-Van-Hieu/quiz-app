import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/services/quiz/quiz_text_parser.dart';

Question parse(String block) {
  final quiz = Quiz(name: 'test');
  QuizTextParser.processFullBlock(block, quiz);
  return quiz.questions.single;
}

List<String> answers(Question q) => q.answers.map((a) => a.content).toList();

List<String> correct(Question q) =>
    q.answers.where((a) => a.isCorrect).map((a) => a.content).toList();

void main() {
  group('Tách đáp án', () {
    test('Không coi "-" trong từ là nhãn đáp án', () {
      final q = parse(
        'Học thuyết Marx-Lenin ra đời khi nào?\n'
        'A. Thế kỷ 19\nB. Thế kỷ 20\nC. Thế kỷ 18\tA',
      );
      expect(q.content, 'Học thuyết Marx-Lenin ra đời khi nào?');
      expect(answers(q), ['Thế kỷ 19', 'Thế kỷ 20', 'Thế kỷ 18']);
      expect(correct(q), ['Thế kỷ 19']);
    });

    test('Không coi chữ cái cuối câu có dấu "." là nhãn', () {
      final q = parse(
        'Theo Hồ Chí Minh. Đâu là nguồn gốc?\n'
        'A. Truyền thống dân tộc\nB. Tinh hoa văn hoá\tB',
      );
      expect(q.content, 'Theo Hồ Chí Minh. Đâu là nguồn gốc?');
      expect(answers(q), ['Truyền thống dân tộc', 'Tinh hoa văn hoá']);
      expect(correct(q), ['Tinh hoa văn hoá']);
    });

    test('Đáp án cùng 1 dòng (OCR)', () {
      final q = parse(
        'Câu 1: Thủ đô của Việt Nam? A. Hà Nội B. Huế C. Sài Gòn\tA',
      );
      expect(q.content, 'Câu 1: Thủ đô của Việt Nam?');
      expect(answers(q), ['Hà Nội', 'Huế', 'Sài Gòn']);
    });

    test('Câu hỏi chứa "Vitamin A." vẫn lấy đúng chuỗi đáp án', () {
      final q = parse(
        'Thiếu Vitamin A. gây bệnh gì?\nA. Quáng gà\nB. Còi xương\tA',
      );
      expect(q.content, 'Thiếu Vitamin A. gây bệnh gì?');
      expect(answers(q), ['Quáng gà', 'Còi xương']);
    });

    test('Đáp án rỗng bị bỏ nhưng không làm lệch nhãn', () {
      final q = parse('Câu hỏi?\nA.\nB. Hai\nC. Ba\tC');
      expect(answers(q), ['Hai', 'Ba']);
      expect(correct(q), ['Ba']);
    });

    test('Giữ thứ tự bằng indexOrder', () {
      final q = parse('Câu hỏi?\nA. Một\nB. Hai\nC. Ba\tA');
      expect(q.answers.map((a) => a.indexOrder).toList(), [0, 1, 2]);
    });
  });

  group('Đánh dấu đáp án đúng', () {
    const term =
        'Tư tưởng Hồ Chí Minh chịu ảnh hưởng của?\n'
        'A. Chủ nghĩa quốc tế\n'
        'B. Chủ nghĩa quốc tế vô sản\n'
        'C. Chủ nghĩa quốc tế cộng sản';

    test(
      'Definition dạng "A. nội dung" chỉ đánh đúng 1 đáp án khớp chính xác',
      () {
        final q = parse('$term\tB. Chủ nghĩa quốc tế vô sản');
        expect(correct(q), ['Chủ nghĩa quốc tế vô sản']);
      },
    );

    test('Definition chỉ có nội dung, khớp chính xác', () {
      final q = parse('$term\tChủ nghĩa quốc tế vô sản');
      expect(correct(q), ['Chủ nghĩa quốc tế vô sản']);
    });

    test(
      'Nội dung khớp chính xác được ưu tiên hơn nhãn (đáp án bị đảo thứ tự)',
      () {
        final q = parse('$term\tA. Chủ nghĩa quốc tế vô sản');
        expect(correct(q), ['Chủ nghĩa quốc tế vô sản']);
      },
    );

    test('Nội dung không khớp thì tin theo nhãn', () {
      final q = parse('$term\tC. Quốc tế cộng sản (sửa lại)');
      expect(correct(q), ['Chủ nghĩa quốc tế cộng sản']);
    });

    test('Nhiều đáp án dạng "A, C"', () {
      final q = parse('$term\tA, C');
      expect(correct(q), ['Chủ nghĩa quốc tế', 'Chủ nghĩa quốc tế cộng sản']);
    });

    test('Không khớp được thì gắn cờ lỗi thay vì đoán bừa', () {
      final q = parse('$term\tChủ nghĩa');
      expect(correct(q), isEmpty);
      expect(q.explanation, startsWith(QuizTextParser.errorFlag));
    });

    test('Khớp gần đúng chọn duy nhất đáp án dài nhất', () {
      final q = parse(
        'Câu hỏi?\nA. Đảng Cộng sản\nB. Nhà nước pháp quyền\t'
        'Đảng Cộng sản Việt Nam',
      );
      expect(correct(q), ['Đảng Cộng sản']);
    });
  });
}
