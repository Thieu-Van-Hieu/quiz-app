import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';

/// Hỏi người dùng có muốn xoá các câu trùng trước khi import hay không.
/// Kết quả: true = xoá trùng, false = giữ nguyên, null = huỷ import.
class DuplicateConfirmDialog extends StatelessWidget {
  final List<Question> duplicates;

  const DuplicateConfirmDialog({super.key, required this.duplicates});

  /// Trả về quiz sau khi xử lý trùng, hoặc null nếu người dùng huỷ import.
  static Future<Quiz?> resolve(BuildContext context, Quiz quiz) async {
    final duplicates = QuizDeduplicator.findDuplicates(quiz.questions);
    if (duplicates.isEmpty) return quiz;

    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (_) => DuplicateConfirmDialog(duplicates: duplicates),
    );
    if (shouldRemove == null) return null;

    if (shouldRemove) {
      final uniqueQuestions = QuizDeduplicator.removeDuplicates(quiz.questions);
      quiz.questions
        ..clear()
        ..addAll(uniqueQuestions);
    }
    return quiz;
  }

  @override
  Widget build(BuildContext context) {
    const previewLimit = 5;

    return AppAlertDialog(
      title: "Phát hiện ${duplicates.length} câu trùng",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Các câu sau trùng nội dung và đáp án với câu đã có trong bộ đề:",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 8),
          for (final q in duplicates.take(previewLimit))
            Text(
              "• ${q.content}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          if (duplicates.length > previewLimit)
            Text(
              "... và ${duplicates.length - previewLimit} câu khác",
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
        ],
      ),
      actions: [
        AppButton(
          label: "Giữ nguyên",
          variant: ButtonVariant.slateOutlined,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          label: "Xoá câu trùng",
          variant: ButtonVariant.danger,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
