import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnswerItem extends HookWidget {
  final int index;
  final String initialValue;
  final bool isCorrect;
  final bool canDelete;
  final Function(String) onChanged;
  final Function(bool) onToggleCorrect;
  final VoidCallback onDelete;

  const AnswerItem({
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
          // 1. Thêm Handle icon để báo hiệu có thể kéo thả
          MouseRegion(
            cursor: SystemMouseCursors.move, // Ép con trỏ ở tầng cao hơn
            child: ReorderableDragStartListener(
              index: index,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors
                      .transparent, // Tạo vùng đệm để nhận diện chuột tốt hơn
                ),
                child: const Icon(
                  Icons.drag_indicator,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),

          Checkbox(
            value: isCorrect,
            activeColor: Colors.green,
            shape: const CircleBorder(),
            onChanged: (val) => onToggleCorrect(val ?? false),
            mouseCursor: SystemMouseCursors.click,
          ),
          const SizedBox(width: 4),

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
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: isCorrect
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
              ),
              onChanged: onChanged,
            ),
          ),

          if (canDelete)
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: onDelete,
              mouseCursor: SystemMouseCursors.click,
            ),
        ],
      ),
    );
  }
}
