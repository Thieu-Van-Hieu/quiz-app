import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';

/// Kết quả kiểm tra trùng chi tiết (port từ utilities/filter.py)
class DuplicateReport {
  /// Nhóm câu trùng cả nội dung lẫn đáp án (an toàn để xoá bớt)
  final List<List<Question>> fullGroups;

  /// Nhóm câu trùng nội dung câu hỏi nhưng KHÁC đáp án (cần người dùng tự kiểm tra)
  final List<List<Question>> contentOnlyGroups;

  const DuplicateReport(this.fullGroups, this.contentOnlyGroups);

  int get removableCount =>
      fullGroups.fold(0, (sum, group) => sum + group.length - 1);

  bool get isEmpty => fullGroups.isEmpty && contentOnlyGroups.isEmpty;
}

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
    final keys =
        answers
            .map((a) => "${normalizeContent(a.content)}|${a.isCorrect}")
            .toList()
          ..sort();

    // Tạo chuỗi dạng: "nội dung|true||nội dung|false"
    return keys.join("||");
  }

  // 3. Hàm kiểm tra trùng
  static String createFingerprint(Question q) {
    final contentKey = normalizeContent(q.content);
    final answerKey = getAnswerSignature(q.answers);
    return "$contentKey::$answerKey";
  }

  // 4. Tìm các câu bị trùng (giữ lại câu xuất hiện đầu tiên, trả về các câu lặp phía sau).
  // Bỏ qua câu nháp chưa có nội dung.
  static List<Question> findDuplicates(Iterable<Question> questions) {
    final seen = <String>{};
    final duplicates = <Question>[];
    for (final q in questions) {
      if (q.content.trim().isEmpty) continue;
      if (!seen.add(createFingerprint(q))) duplicates.add(q);
    }
    return duplicates;
  }

  // 5. Trả về danh sách mới đã bỏ các câu trùng
  static List<Question> removeDuplicates(List<Question> questions) {
    final duplicates = findDuplicates(questions).toSet();
    return questions.where((q) => !duplicates.contains(q)).toList();
  }

  // 6. Phân nhóm câu trùng: trùng hoàn toàn / chỉ trùng nội dung câu hỏi
  static DuplicateReport findDuplicateGroups(Iterable<Question> questions) {
    final byContent = <String, List<Question>>{};
    for (final q in questions) {
      final key = normalizeContent(q.content);
      if (key.isEmpty) continue;
      byContent.putIfAbsent(key, () => []).add(q);
    }

    final fullGroups = <List<Question>>[];
    final contentOnlyGroups = <List<Question>>[];
    for (final group in byContent.values.where((g) => g.length > 1)) {
      final byFingerprint = <String, List<Question>>{};
      for (final q in group) {
        byFingerprint.putIfAbsent(createFingerprint(q), () => []).add(q);
      }
      fullGroups.addAll(byFingerprint.values.where((g) => g.length > 1));
      // Cùng nội dung nhưng có >= 2 bộ đáp án khác nhau
      if (byFingerprint.length > 1) contentOnlyGroups.add(group);
    }
    return DuplicateReport(fullGroups, contentOnlyGroups);
  }
}
