import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OptionItem extends HookWidget {
  final int index;
  final String initialValue;
  final bool isCorrect;
  final bool canDelete;
  final Function(String) onChanged;
  final Function(bool) onToggleCorrect;
  final VoidCallback onDelete;

  const OptionItem({
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
    // Controller riêng cho từng option để gõ mượt, không bị lag
    final controller = useTextEditingController(text: initialValue);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Checkbox(
            value: isCorrect,
            activeColor: Colors.green,
            shape: const CircleBorder(),
            onChanged: (val) => onToggleCorrect(val ?? false),
          ),
          const SizedBox(width: 8),
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
            ),
        ],
      ),
    );
  }
}
