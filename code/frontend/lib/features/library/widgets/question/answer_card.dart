import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/action_button.dart'; // Import nút action_button hệ thống

class AnswerCard extends HookWidget {
  final int index;
  final String initialValue;
  final bool isCorrect;
  final bool canDelete;
  final Function(String) onChanged;
  final Function(bool) onToggleCorrect;
  final VoidCallback onDelete;

  const AnswerCard({
    super.key,
    required this.index,
    required this.initialValue,
    required this.isCorrect,
    required this.canDelete,
    required this.onChanged,
    required this.onToggleCorrect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);

    useEffect(() {
      if (controller.text != initialValue) {
        controller.text = initialValue;
      }
      return null;
    }, [initialValue]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // 1. Handle icon kéo thả mượt mà
          MouseRegion(
            cursor: SystemMouseCursors.move,
            child: ReorderableDragStartListener(
              index: index,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: const Icon(
                  Icons.drag_indicator,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          // 2. Checkbox đáp án đúng
          Checkbox(
            value: isCorrect,
            activeColor: const Color(
              0xFF22C55E,
            ), // Xanh lục mướt chuẩn thiết kế mới
            shape: const CircleBorder(),
            onChanged: (val) => onToggleCorrect(val ?? false),
            mouseCursor: SystemMouseCursors.click,
          ),
          const SizedBox(width: 4),

          // 3. Ô nhập nội dung đáp án
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Đáp án ${index + 1}...",
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: isCorrect
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF22C55E),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
              ),
              onChanged: onChanged,
            ),
          ),

          // 4. Áp dụng AppActionButton đồng bộ với hệ thống nút của Card mẹ
          if (canDelete) ...[
            const SizedBox(width: 8),
            AppActionButton(
              onTap: onDelete,
              actionType: ActionType.delete,
              style: ActionButtonStyle.tonal,
              tooltip: "Xóa đáp án này",
            ),
          ],
        ],
      ),
    );
  }
}
