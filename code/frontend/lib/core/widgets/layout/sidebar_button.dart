import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';

class SidebarButton extends HookWidget {
  final String title;
  final IconData? icon;
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
    // Trạng thái thu nhỏ dựa trên việc tiêu đề có trống hay không
    final bool isCollapsed = title.isEmpty;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      // CÁCH 2: Ép con trỏ chuột luôn là bàn tay cho toàn bộ vùng bấm
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56.0),
          decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(
                color: DashboardColors.sidebarHeader,
                width: 0.5,
              ),
            ),
            color: isSelected
                ? DashboardColors.sidebarActive
                : (isHovered.value
                      ? DashboardColors.sidebarHover
                      : Colors.transparent),
          ),
          // Clip để tránh lỗi sọc vàng đen khi đang animation thu hẹp không gian
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 56,
            child: Stack(
              children: [
                // Phần hiển thị Icon
                if (icon != null)
                  Positioned(
                    left: 0,
                    width: isCollapsed ? 56 : 60,
                    // Cố định chiều rộng vùng chứa icon
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        icon,
                        size: 20,
                        color: isSelected ? Colors.blue[800] : Colors.black54,
                      ),
                    ),
                  ),

                // Phần hiển thị Text (Chỉ hiện khi không thu gọn)
                if (!isCollapsed)
                  Positioned(
                    left: 52,
                    // Khoảng cách từ lề trái đến chữ (Icon 20px + Padding 20px + Spacing)
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.blue[900] : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                // Vạch chỉ báo đang chọn (Active Indicator)
                if (isSelected)
                  Positioned(
                    right: 0,
                    top: 15,
                    bottom: 15,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(2),
                        ),
                      ),
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
