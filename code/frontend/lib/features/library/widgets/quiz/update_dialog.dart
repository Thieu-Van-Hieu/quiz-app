import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';

class UpdateQuizDialog extends HookWidget {
  final Quiz quiz;
  final Function(String) onUpdate;

  const UpdateQuizDialog({
    super.key,
    required this.quiz,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller với giá trị tên hiện tại của quiz
    final controller = useTextEditingController(text: quiz.name);

    return AppAlertDialog(
      title: LibraryStrings.dialogUpdateQuizTitle,
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
          label: AppStrings.btnUpdate,
          variant: ButtonVariant.indigo,
          size: ButtonSize.small,
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              onUpdate(value);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
