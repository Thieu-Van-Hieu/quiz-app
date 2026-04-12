// lib/features/library/widgets/retro_checkbox.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';

class RetroCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?>?
  onChanged; // Đổi thành nullable để hỗ trợ disabled state
  final Color? color;

  const RetroCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.color = LearningColors.windowsBlack,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Khi onChanged là null, InkWell sẽ tự động disable và đổi cursor về basic
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      mouseCursor: SystemMouseCursors.click, // Thêm dòng này để hiện bàn tay
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // Thêm chút horizontal để dễ bấm
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: LearningColors.retroInputBackground,
                border: Border.all(
                  color: LearningColors.windowsBlack,
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: LearningColors.windowsGrey,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: value ? Icon(Icons.check, size: 14, color: color) : null,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color,
                // Nếu muốn text mờ đi khi disabled có thể thêm logic ở đây
              ),
            ),
          ],
        ),
      ),
    );
  }
}
