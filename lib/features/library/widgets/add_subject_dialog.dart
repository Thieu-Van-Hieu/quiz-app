import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddSubjectDialog extends HookConsumerWidget {
  const AddSubjectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dùng Hook để quản lý controller ngay trong Dialog
    final nameCtrl = useTextEditingController();
    final codeCtrl = useTextEditingController();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogAddTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400, // Cố định chiều rộng để Dialog không bị co giãn
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelName,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book_rounded),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelCode,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_rounded),
              ),
              // Tự động viết hoa mã môn học cho chuyên nghiệp
              onChanged: (val) => codeCtrl.value = codeCtrl.value.copyWith(
                text: val.toUpperCase(),
                selection: TextSelection.collapsed(offset: val.length),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(LibraryStrings.btnCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (nameCtrl.text.trim().isNotEmpty &&
                codeCtrl.text.trim().isNotEmpty) {
              final newSub = Subject()
                ..name = nameCtrl.text.trim()
                ..code = codeCtrl.text.trim().toUpperCase();

              // Gọi Notifier để lưu vào Isar
              ref.read(subjectNotifierProvider.notifier).saveSubject(newSub);

              Navigator.pop(context); // Đóng dialog sau khi lưu
            }
          },
          child: const Text(LibraryStrings.btnSave),
        ),
      ],
    );
  }
}
