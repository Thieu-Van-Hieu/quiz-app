import 'package:flutter/material.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';

class EosProgressRow extends StatelessWidget {
  final int answeredCount;
  final int totalQuestions;
  final Color bgColor;
  final Color progressColor;
  final Color textColor;

  const EosProgressRow({
    super.key,
    required this.answeredCount,
    required this.totalQuestions,
    // Thiết lập mặc định ngay tại đây
    this.bgColor = LearningColors.windowsBackground,
    this.progressColor = const Color(0xFF388E3C), // Màu Green.shade700
    this.textColor = LearningColors.eosNavy,
  });

  @override
  Widget build(BuildContext context) {
    // Tính toán giá trị progress (0.0 -> 1.0)
    final double progressValue = totalQuestions > 0
        ? (answeredCount / totalQuestions).clamp(0.0, 1.0)
        : 0.0;

    // Tính phần nhãn phần trăm (VD: 10%)
    final int percentage = (progressValue * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        children: [
          // Text thông báo tiến độ
          Text(
            "There are $totalQuestions questions, and your progress of answering is $percentage%",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),

          // Thanh Progress Bar
          Expanded(
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white,
                // Luôn dùng màu progress đã khởi tạo
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
