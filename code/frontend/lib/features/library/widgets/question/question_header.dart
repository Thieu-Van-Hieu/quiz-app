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
        // Nút quay lại (Giữ nguyên IconButton hoặc bạn có thể thay bằng ActionButton tròn nhỏ nếu thích)
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: 16),

        // --- CỤM TIÊU ĐỀ BÊN TRÁI ---
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

        // --- CỤM NÚT ĐỒ HỒNG 3D HỆ THỐNG BÊN PHẢI ---

        // Thay thế đoạn Cụm Nút bên phải trong file QuestionHeader của bạn:

        // 1. QUÉT ẢNH: Tác vụ thông minh đi kèm -> Dùng BrandOutlined nhẹ nhàng nhưng vẫn đồng bộ tông Mint
        AppButton(
          onPressed: onOcrTap,
          icon: Icons.camera_enhance_rounded,
          label: "Quét ảnh",
          variant: ButtonVariant.brandOutlined, // 🆕 Sắp xếp phân cấp trực quan
          size: ButtonSize.medium,
        ),
        const SizedBox(width: 16),

        // 2. TẢI LẠI: Tác vụ phụ hệ thống -> Dùng SlateOutlined (Chữ xám nền trắng) không chiếm spotlight
        AppButton(
          onPressed: onRefreshTap,
          icon: Icons.refresh_rounded,
          label: "Tải lại",
          variant: ButtonVariant.slateOutlined, // 🆕 Thay đổi cực kỳ tinh tế
          size: ButtonSize.medium,
        ),
        const SizedBox(width: 16),

        // 3. LƯU DB: Lưu trữ hệ thống chắc chắn -> Dùng Slate Solid (Xám đá đậm) cực uy tín
        AppButton(
          onPressed: onSaveTap,
          icon: Icons.cloud_upload_outlined,
          label: "Lưu DB",
          variant:
              ButtonVariant.slate, // 🆕 Tạo cảm giác lưu trữ an toàn, chắc chắn
          size: ButtonSize.medium,
        ),
        const SizedBox(width: 16),

        // 4. THÊM CÂU HỎI: Hành động chính tối thượng (Primary Call-To-Action) -> Giữ Brand Mint Solid đậm đà nhất để hút mắt người dùng bấm vào
        AppButton(
          onPressed: onAddTap,
          icon: Icons.add_rounded,
          label: "Thêm câu hỏi",
          variant: ButtonVariant.brand, // ⭐ Ngôi sao sáng nhất hàng nút
          size: ButtonSize.medium,
        ),
      ],
    );
  }
}
