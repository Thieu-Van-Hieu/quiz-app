import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onDelete;

  const DeleteConfirmDialog({
    super.key,
    required this.itemName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: AppStrings.deleteConfirmTitle,
      size: AlertDialogSize.medium, // Kích thước 450px phù hợp cho confirm box
      content: Text(
        "${LibraryStrings.deleteConfirmContent}\n\nĐang chọn: $itemName",
        style: const TextStyle(fontSize: 14, height: 1.5),
      ),
      actions: [
        // Nút Xóa sử dụng ElevatedButton gốc của bạn hoặc AppButton (tùy bạn chọn)
        AppButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context); // Đóng Dialog sau khi thực hiện xóa
          },
          label: "Xóa",
          variant: ButtonVariant.danger,
          size: ButtonSize.small,
        ),
      ],
    );
  }
}
