import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';

class QuizletExportDialog extends HookWidget {
  const QuizletExportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final termDefSep = useTextEditingController(text: "\\t");
    final rowSep = useTextEditingController(text: "\\n");

    return AlertDialog(
      title: const Text("Cấu hình định dạng Export"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildField(
            "Dấu giữa Câu hỏi & Đáp án (Term-Def):",
            termDefSep,
            "\\t (Tab)",
          ),
          const SizedBox(height: 16),
          _buildField(
            "Dấu giữa các hàng (Giữa các câu):",
            rowSep,
            "\\n (Xuống dòng)",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'termDef': termDefSep.text,
            'row': rowSep.text,
          }),
          style: ElevatedButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Sao chép dữ liệu"),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.searchBarBg,
          ),
        ),
      ],
    );
  }
}
