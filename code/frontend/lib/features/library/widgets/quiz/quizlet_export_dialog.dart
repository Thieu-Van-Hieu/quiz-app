import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';

class QuizletExportDialog extends HookWidget {
  const QuizletExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final termDefSep = useTextEditingController(text: "\\t");
    final rowSep = useTextEditingController(text: "\\n");

    return AppAlertDialog(
      title: "Cấu hình định dạng Export",
      size: AlertDialogSize.medium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          AppTextField(
            label: "Dấu giữa Câu hỏi & Đáp án (Term-Def):",
            hintText: "\\t (Tab)",
            controller: termDefSep,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: "Dấu giữa các hàng (Giữa các câu):",
            hintText: "\\n (Xuống dòng)",
            controller: rowSep,
          ),
        ],
      ),
      actions: [
        AppButton(
          label: "Sao chép dữ liệu",
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context, {
            'termDef': termDefSep.text,
            'row': rowSep.text,
          }),
        ),
      ],
    );
  }
}
