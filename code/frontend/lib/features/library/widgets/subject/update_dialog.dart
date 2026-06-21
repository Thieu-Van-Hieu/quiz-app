import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
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

    return AppAlertDialog(
      title: LibraryStrings.dialogUpdateSubjectTitle,
      size: AlertDialogSize.medium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AppTextField(
            label: LibraryStrings.dialogLabelSubjectCode,
            hintText: LibraryStrings.hintSubjectCode,
            controller: codeController,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: LibraryStrings.dialogLabelSubjectName,
            hintText: LibraryStrings.hintSubjectName,
            controller: nameController,
          ),
        ],
      ),
      actions: [
        AppButton(
          label: AppStrings.btnUpdate,
          variant: ButtonVariant.indigo,
          size: ButtonSize.small,
          onPressed: () {
            if (nameController.text.trim().isNotEmpty &&
                codeController.text.trim().isNotEmpty) {
              onUpdate(nameController.text.trim(), codeController.text.trim());
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
