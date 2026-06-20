import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppSearchBar extends HookWidget {
  final String hintText;
  final Function(String) onSearch;
  final double maxWidth;

  const AppSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = "Tìm kiếm...",
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    // Dùng cái này để lắng nghe trạng thái re-render khi user gõ chữ (hiện/ẩn nút Xóa)
    final hasText = useValueListenable(controller);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        width: double.infinity,
        // Giới hạn chiều cao sàn tối thiểu 50px như cũ của bạn
        constraints: const BoxConstraints(minHeight: 50.0, minWidth: 324.0),
        decoration: BoxDecoration(
          color: AppColors.searchBarBg, // #F5F6FA trắng xám nhẹ
          // Tăng bo góc lên 16 để khớp với form kute của Card và AppButton
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: controller,
          onChanged: onSearch,
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 15,
            fontWeight: FontWeight.w600, // Cho chữ gõ vào đậm đà rõ nét
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            // Đưa Icon Search dịch vào trong mượt mà
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.secondaryText,
                size: 22,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),

            // Nút xóa text (X) tròn kẹo ngọt xuất hiện mượt mà
            suffixIcon: hasText.text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.secondaryText,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.clear();
                        onSearch('');
                      },
                    ),
                  )
                : null,

            // CẤU HÌNH BORDER CHỐNG MỜ NHẠT (TẠO RÃNH CHÌM)
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: InputBorder.none,

            // Viền mặc định khi bình thường (Màu xám pastel nhẹ giúp phân tách rõ với nền App)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 2.0,
              ), // Viền rãnh 2px sắc nét
            ),

            // Viền khi người dùng Click chuột vào gõ (Đổi sang màu Brand Xanh Mint của bạn)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.brandShadow,
                width: 2.0,
              ), // Ăn theo màu xanh mint đậm đà
            ),
          ),
        ),
      ),
    );
  }
}
