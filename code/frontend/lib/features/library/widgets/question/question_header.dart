import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/widgets/question/header_button.dart';

class QuestionHeader extends StatelessWidget {
  final String quizName;
  final int numberOfQuestion;
  final VoidCallback onOcrTap;
  final VoidCallback onRefreshTap;
  final VoidCallback onSaveTap;
  final VoidCallback onAddTap;

  const QuestionHeader({
    super.key,
    required this.quizName,
    required this.numberOfQuestion,
    required this.onOcrTap,
    required this.onRefreshTap,
    required this.onSaveTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: LibraryColors.primaryText,
              ),
            ),
            Text(
              "$numberOfQuestion câu hỏi hiện có",
              style: const TextStyle(color: LibraryColors.secondaryText),
            ),
          ],
        ),
        const Spacer(),
        QuestionHeaderButton(
          onPressed: onOcrTap,
          icon: Icons.camera_enhance_rounded,
          label: "Quét ảnh",
          color: LibraryColors.accentColor,
        ),
        const SizedBox(width: 16),
        QuestionHeaderButton(
          onPressed: onRefreshTap,
          icon: Icons.refresh_rounded,
          label: "Tải lại",
          color: LibraryColors.secondaryText,
        ),
        const SizedBox(width: 16),
        QuestionHeaderButton(
          onPressed: onSaveTap,
          icon: Icons.cloud_upload_outlined,
          label: "Lưu DB",
          color: AppColors.success,
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: onAddTap,
          icon: const Icon(Icons.add_rounded),
          label: const Text("Thêm câu hỏi"),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
