import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class AddQuizDialog extends HookWidget {
  final Function(String) onSave;
  const AddQuizDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return AppAlertDialog(
      title: LibraryStrings.dialogAddQuizTitle,
      size: AlertDialogSize.medium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AppTextField(
            label: LibraryStrings.dialogLabelQuizName,
            hintText: LibraryStrings.hintQuizName,
            controller: controller,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        AppButton(
          label: AppStrings.btnSave,
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              onSave(value);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
