import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class AddSubjectDialog extends HookWidget {
  final Function(String name, String code) onSave;

  const AddSubjectDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = useTextEditingController();
    final codeCtrl = useTextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogAddSubjectTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mã môn: Nhập thoải mái (thường hay hoa đều được)
            TextField(
              controller: codeCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelSubjectCode,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_rounded),
                helperText: "Ví dụ: int101 hoặc INT101",
              ),
            ),
            const SizedBox(height: 20),
            // Tên môn
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelSubjectName,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book_rounded),
                helperText: "Để trống sẽ lấy mã môn làm tên",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(AppStrings.btnCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            // Lấy text thô (giữ nguyên chữ thường/hoa)
            final code = codeCtrl.text.trim();
            final name = nameCtrl.text.trim();

            // 1. Kiểm tra validation
            if (code.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Vui lòng nhập mã môn học"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior
                      .floating, // Hiển thị đẹp hơn trong dialog
                ),
              );
              return;
            }

            // 2. Xử lý dữ liệu chuẩn bị gửi đi (Viết hoa mã, lấy mã làm tên nếu tên trống)
            final finalCode = code;
            final finalName = name.isEmpty ? finalCode : name;

            // 3. Thực hiện lưu
            await onSave(finalName, finalCode);

            // 4. Đóng dialog
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            AppStrings.btnSave,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
