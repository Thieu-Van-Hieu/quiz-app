import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/library/constants/library_colors.dart';

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
        // Nút quay lại
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: 16),

        // --- CỤM TIÊU ĐỀ BÊN TRÁI (Bọc Expanded để tránh tràn khi tên quiz dài) ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                quizName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // 🆕 Hiện dấu "..." nếu tên dài
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
        ),

        const SizedBox(width: 16),

        // --- CỤM NÚT BÊN PHẢI (Bọc SingleChildScrollView ngang để chống tràn màn hình nhỏ) ---
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. QUÉT ẢNH
              AppButton(
                onPressed: onOcrTap,
                icon: Icons.camera_enhance_rounded,
                label: "Quét ảnh",
                variant: ButtonVariant.brandOutlined,
                size: ButtonSize.medium,
              ),
              const SizedBox(width: 12),

              // 2. TẢI LẠI
              AppButton(
                onPressed: onRefreshTap,
                icon: Icons.refresh_rounded,
                label: "Tải lại",
                variant: ButtonVariant.slateOutlined,
                size: ButtonSize.medium,
              ),
              const SizedBox(width: 12),

              // 3. LƯU DB
              AppButton(
                onPressed: onSaveTap,
                icon: Icons.cloud_upload_outlined,
                label: "Lưu DB",
                variant: ButtonVariant.slate,
                size: ButtonSize.medium,
              ),
              const SizedBox(width: 12),

              // 4. THÊM CÂU HỎI
              AppButton(
                onPressed: onAddTap,
                icon: Icons.add_rounded,
                label: "Thêm câu hỏi",
                variant: ButtonVariant.brand,
                size: ButtonSize.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
