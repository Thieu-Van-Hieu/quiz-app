import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';

class QuizDeduplicator {
  // 1. Hàm làm sạch nội dung câu hỏi
  static String normalizeContent(String content) {
    String text = content.toLowerCase().trim();

    // Regex xóa các loại "noise": (lặp), [copy], (1), (2), (bản sao)...
    // Bạn có thể thêm các từ khóa noise khác vào đây
    final noiseRegex = RegExp(
      r'(\s*\(.*(lặp|copy|dự phòng|bản sao|fix|edited).*\))|(\s*\(\d+\)\s*)',
      caseSensitive: false,
    );

    return text
        .replaceAll(noiseRegex, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // 2. Hàm tạo "chữ ký" cho đáp án (để đảm bảo so sánh đúng kể cả khi đảo thứ tự)
  static String getAnswerSignature(List<Answer> answers) {
    // Sort theo nội dung để thứ tự A, B, C không ảnh hưởng
    final sorted = List.of(answers)
      ..sort((a, b) => a.content.compareTo(b.content));

    // Tạo chuỗi dạng: "A:Nội dung|true||B:Nội dung|false"
    return sorted.map((a) => "${a.content.trim()}|${a.isCorrect}").join("||");
  }

  // 3. Hàm kiểm tra trùng
  static String createFingerprint(Question q) {
    final contentKey = normalizeContent(q.content);
    final answerKey = getAnswerSignature(q.answers);
    return "$contentKey::$answerKey";
  }
}
