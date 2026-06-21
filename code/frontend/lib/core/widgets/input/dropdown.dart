import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.initialValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Thừa hưởng border dày dặn đặc trưng của hệ thống 3D
    const borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ), // Đồng bộ bo góc 16px như các button/card
      borderSide: BorderSide(color: AppColors.slate, width: 2.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LABEL PHÍA TRÊN ---
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700, // Chữ dày dặn, mộc mạc
            fontSize: 14,
            color: AppColors.toastText,
          ),
        ),
        const SizedBox(height: 8),

        // --- KHU VỰC DROPDOWN KHỐI NỔI 3D ---
        Container(
          // Hiệu ứng đổ bóng khối cứng (không blur) đặc trưng tạo cảm giác 3D phẳng
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.slate.withValues(alpha: 0.2),
                blurRadius: 0,
                offset: const Offset(0, 4), // Đẩy bóng xuống tạo độ dày khối
              ),
            ],
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<T>(
              initialValue: initialValue,
              items: items,
              onChanged: onChanged,
              dropdownMenuItemMouseCursor: SystemMouseCursors.click,
              style: const TextStyle(
                color: AppColors.toastText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor:
                  Colors.white, // Nền menu dropdown khi bung ra sạch sẽ
              borderRadius: BorderRadius.circular(16),
              mouseCursor: SystemMouseCursors.click,
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.secondaryText,
                size: 22,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Colors.white, // Đồng bộ màu nền với các ô nhập liệu khác
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: borderStyle,
                focusedBorder: borderStyle.copyWith(
                  borderSide: const BorderSide(
                    color: AppColors
                        .brandShadow, // Khi tương tác đổi sang màu chủ đạo (ví dụ mint hoặc xanh của bạn)
                    width: 2.0,
                  ),
                ),
                border: borderStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
