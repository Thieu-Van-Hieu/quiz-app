import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';

class UpdateSubjectDialog extends HookWidget {
  final Subject subject;
  // Truyền cả name và code về để Page/Notifier xử lý
  final Function(String name, String code) onUpdate;

  const UpdateSubjectDialog({
    super.key,
    required this.subject,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: subject.name);
    final codeController = useTextEditingController(text: subject.code);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogUpdateSubjectTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            LibraryStrings.dialogLabelSubjectCode,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: codeController,
            decoration: InputDecoration(
              hintText: LibraryStrings.hintSubjectCode,
              filled: true,
              fillColor: AppColors.searchBarBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            LibraryStrings.dialogLabelSubjectName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: LibraryStrings.hintSubjectName,
              filled: true,
              fillColor: AppColors.searchBarBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(
            LibraryStrings.btnCancel,
            style: TextStyle(color: LibraryColors.secondaryText),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                codeController.text.isNotEmpty) {
              onUpdate(nameController.text, codeController.text);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: const Text(
            LibraryStrings.btnUpdate,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
