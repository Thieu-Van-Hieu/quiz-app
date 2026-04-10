import 'package:flutter/material.dart';
// Giả sử đường dẫn này đã có sẵn trong project của bạn
import 'package:frontend/features/learning/constants/learning_colors.dart';

class RetroButton extends StatelessWidget {
  final String label;
  final Color? color;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const RetroButton({
    super.key,
    required this.label,
    this.color,
    this.width = 60,
    this.height = 28,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Nếu có onTap thì hiện bàn tay, không thì hiện mũi tên mặc định
      cursor: onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.6 : 1.0,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color ?? LearningColors.retroButtonBackground,
              border: Border.all(
                color: LearningColors.retroButtonBorder,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1.5, -1.5),
                  spreadRadius: 0,
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1.5, 1.5),
                  spreadRadius: 0,
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
