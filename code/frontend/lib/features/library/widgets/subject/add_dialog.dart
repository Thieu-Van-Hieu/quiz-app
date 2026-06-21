import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart'; // Import đúng đường dẫn AppTextField của bạn
import 'package:frontend/features/library/constants/library_strings.dart';

class AddSubjectDialog extends HookWidget {
  final Function(String name, String code) onSave;

  const AddSubjectDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = useTextEditingController();
    final codeCtrl = useTextEditingController();

    return AppAlertDialog(
      title: LibraryStrings.dialogAddSubjectTitle,
      size: AlertDialogSize.medium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          AppTextField(
            label: LibraryStrings.dialogLabelSubjectCode,
            hintText: "Ví dụ: int101 hoặc INT101",
            controller: codeCtrl,
            autofocus: true,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: LibraryStrings.dialogLabelSubjectName,
            hintText: "Để trống sẽ lấy mã môn làm tên",
            controller: nameCtrl,
          ),
        ],
      ),
      actions: [
        AppButton(
          label: AppStrings.btnSave,
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          onPressed: () async {
            final code = codeCtrl.text.trim();
            final name = nameCtrl.text.trim();

            if (code.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Vui lòng nhập mã môn học"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            final finalCode = code;
            final finalName = name.isEmpty ? finalCode : name;

            await onSave(finalName, finalCode);

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
