import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class AddSubjectDialog extends HookWidget {
  // Page sẽ quyết định làm gì với name và code này
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
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelSubjectName,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book_rounded),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(
                labelText: LibraryStrings.dialogLabelSubjectCode,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code_rounded),
              ),
              onChanged: (val) {
                // Giữ nguyên logic viết hoa mã môn cho xịn
                final upper = val.toUpperCase();
                if (codeCtrl.text != upper) {
                  codeCtrl.value = codeCtrl.value.copyWith(
                    text: upper,
                    selection: TextSelection.collapsed(offset: upper.length),
                  );
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(enabledMouseCursor: SystemMouseCursors.click),
          child: const Text(LibraryStrings.btnCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: () {
            final name = nameCtrl.text.trim();
            final code = codeCtrl.text.trim().toUpperCase();
            
            if (name.isNotEmpty && code.isNotEmpty) {
              onSave(name, code); // Bắn data về Page
              Navigator.pop(context); 
            }
          },
          child: const Text(LibraryStrings.btnSave, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
