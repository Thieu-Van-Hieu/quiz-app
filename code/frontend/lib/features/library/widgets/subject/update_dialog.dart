import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';

class UpdateSubjectDialog extends HookWidget {
  final Subject subject;
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
      backgroundColor: AppColors.toastBackground,
      // Dùng màu trắng từ AppColors
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogUpdateSubjectTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.toastText, // Dùng màu text tối của Toast cho đồng bộ
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            LibraryStrings.dialogLabelSubjectCode,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.toastText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: codeController,
            style: const TextStyle(color: AppColors.toastText),
            decoration: InputDecoration(
              hintText: LibraryStrings.hintSubjectCode,
              hintStyle: const TextStyle(color: AppColors.secondaryText),
              filled: true,
              fillColor: AppColors.textFieldFill,
              // Dùng màu xám nhạt phen đã định nghĩa
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            LibraryStrings.dialogLabelSubjectName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.toastText,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.toastText),
            decoration: InputDecoration(
              hintText: LibraryStrings.hintSubjectName,
              hintStyle: const TextStyle(color: AppColors.secondaryText),
              filled: true,
              fillColor: AppColors.textFieldFill,
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
            AppStrings.btnCancel,
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.trim().isNotEmpty &&
                codeController.text.trim().isNotEmpty) {
              onUpdate(nameController.text.trim(), codeController.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.infoBlue,
            // Dùng màu xanh này làm Accent/Primary
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledMouseCursor: SystemMouseCursors.click,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            AppStrings.btnUpdate,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
