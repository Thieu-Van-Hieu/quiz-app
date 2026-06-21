import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppMenuItem {
  final int value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  const AppMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });
}

class AppMenu {
  static Future<int?> show({
    required BuildContext context,
    required BuildContext buttonContext,
    required List<AppMenuItem> items,
    double offsetTop = 12.0, // Khoảng cách giãn cách từ nút xuống menu
  }) {
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    // Công thức tính toán RelativeRect chuẩn xác tuyệt đối để ép menu luôn mở ở phía dưới nút
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(0, button.size.height + offsetTop),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + Offset(0, offsetTop),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    return showMenu<int>(
      context: context,
      position: position,
      elevation: 0, // Tắt bóng đổ mặc định để giữ vibe mộc mạc
      constraints: const BoxConstraints(minWidth: 170),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.slate.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      color: Colors.white,
      items: items.map((item) {
        return PopupMenuItem<int>(
          value: item.value,
          height: 44,
          child: MouseRegion(
            cursor: SystemMouseCursors
                .click, // Tạo cursor bàn tay khi hover vào item trên Web/Desktop
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: item.iconColor ?? AppColors.secondaryText,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.toastText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
