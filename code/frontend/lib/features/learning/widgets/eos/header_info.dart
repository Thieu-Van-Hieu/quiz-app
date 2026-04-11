import 'package:flutter/material.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';

class HeaderInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const HeaderInfo({
    super.key,
    required this.label,
    required this.value,
    this.color = LearningColors.eosPrimaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ), // Tăng từ 11 lên 13
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
