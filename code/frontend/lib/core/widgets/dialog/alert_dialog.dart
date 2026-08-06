import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/widgets/button/button.dart';

enum AlertDialogSize { small, medium, big }

class AppAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final AlertDialogSize size;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.size = AlertDialogSize.medium,
  });

  // Tỉ lệ % chiều rộng màn hình theo Enum
  double get _widthFactor {
    switch (size) {
      case AlertDialogSize.small:
        return 0.35; // 35% screen width
      case AlertDialogSize.medium:
        return 0.55; // 55% screen width
      case AlertDialogSize.big:
        return 0.80; // 80% screen width
    }
  }

  // Giới hạn max-width để không bị bẹt ra quá to trên màn hình lớn/PC
  double get _maxWidth {
    switch (size) {
      case AlertDialogSize.small:
        return 400;
      case AlertDialogSize.medium:
        return 800;
      case AlertDialogSize.big:
        return 1200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Tính toán chiều rộng dynamic:
    // Lấy theo % màn hình nhưng tối thiểu là 280px (để mobile k bị quá nhỏ)
    // và tối đa là _maxWidth (để web/desktop k bị nở bung)
    final targetWidth = (screenWidth * _widthFactor).clamp(280.0, _maxWidth);

    return AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: DynamicDialogContent(width: targetWidth, child: content),
      actions: [
        AppButton(
          label: "Hủy",
          variant: ButtonVariant.slate,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context),
        ),
        ...(actions ?? []),
      ],
      actionsPadding: const EdgeInsets.all(16),
    );
  }
}

// Sub-widget tối ưu chiều cao tránh overflow khi tỉ lệ màn hình thay đổi
class DynamicDialogContent extends StatelessWidget {
  final double width;
  final Widget child;

  const DynamicDialogContent({
    super.key,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
        minWidth: width,
        // Giới hạn chiều cao tối đa bằng 80% chiều cao màn hình
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: child,
    );
  }
}
