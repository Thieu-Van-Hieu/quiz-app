import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';

class SidebarButton extends HookWidget {
  final String title;
  final IconData? icon; // Thêm Icon để menu chuyên nghiệp hơn
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarButton({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      cursor: SystemMouseCursors.click, // Hiện bàn tay khi rê chuột vào
      child: GestureDetector(
        // Dùng GestureDetector hoặc InkWell đều được
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          // Hiệu ứng đổi màu mượt
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56.0),
          // 56-64 là chuẩn
          decoration: BoxDecoration(
            // Đường kẻ mờ ngăn cách các item
            border: const Border(
              bottom: BorderSide(color: AppColors.sidebarBorder, width: 0.5),
            ),
            color: isSelected
                ? AppColors.sidebarActive
                : (isHovered.value
                      ? AppColors.sidebarHover
                      : Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // Căn lề trái nhìn thuận mắt hơn trên Desktop
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.blue[800] : Colors.black54,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16, // 16-18 là vừa đủ dùng
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected ? Colors.blue[900] : Colors.black87,
                    ),
                  ),
                ),
                // Thanh chỉ thị (Indicator) nhỏ bên trái nếu đang chọn (Option)
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
