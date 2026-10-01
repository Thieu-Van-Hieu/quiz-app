import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';

/// Tiêu chí coi 2 câu là trùng khi gộp
enum MergeDuplicateCriteria {
  contentAndAnswers("Trùng cả câu hỏi và đáp án"),
  content("Chỉ cần trùng nội dung câu hỏi"),
  none("Không kiểm tra trùng");

  final String label;

  const MergeDuplicateCriteria(this.label);
}

/// Cách xử lý khi gặp câu trùng
enum MergeDuplicateAction {
  skip("Giữ câu có trước, bỏ câu sau"),
  replace("Thay bằng câu của bộ đề sau");

  final String label;

  const MergeDuplicateAction(this.label);
}

class MergeResult {
  final List<Question> questions;
  final int inputCount;
  final int duplicateCount;

  const MergeResult({
    required this.questions,
    required this.inputCount,
    required this.duplicateCount,
  });
}

/// Gộp nhiều bộ đề (port từ utilities/index.html).
/// Khác bản JS: so trùng bằng nội dung đã chuẩn hoá thay vì "chứa chuỗi",
/// tránh việc câu ngắn bị coi là trùng với mọi câu dài chứa nó.
class QuizMerger {
  static String? _key(Question q, MergeDuplicateCriteria criteria) {
    if (q.content.trim().isEmpty) return null; // Câu nháp rỗng không gộp trùng
    return switch (criteria) {
      MergeDuplicateCriteria.contentAndAnswers =>
        QuizDeduplicator.createFingerprint(q),
      MergeDuplicateCriteria.content => QuizDeduplicator.normalizeContent(
        q.content,
      ),
      MergeDuplicateCriteria.none => null,
    };
  }

  static MergeResult merge(
    List<List<Question>> quizzes, {
    MergeDuplicateCriteria criteria = MergeDuplicateCriteria.contentAndAnswers,
    MergeDuplicateAction action = MergeDuplicateAction.skip,
  }) {
    final result = <Question>[];
    final positionByKey = <String, int>{};
    var inputCount = 0, duplicateCount = 0;

    for (final questions in quizzes) {
      for (final q in questions) {
        inputCount++;
        final key = _key(q, criteria);
        final existing = key == null ? null : positionByKey[key];

        if (existing == null) {
          if (key != null) positionByKey[key] = result.length;
          result.add(q);
          continue;
        }

        duplicateCount++;
        if (action == MergeDuplicateAction.replace) result[existing] = q;
      }
    }

    return MergeResult(
      questions: result,
      inputCount: inputCount,
      duplicateCount: duplicateCount,
    );
  }
}
