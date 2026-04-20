import 'package:flutter/material.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';

class EosProgressRow extends StatefulWidget {
  final int answeredCount;
  final int totalQuestions;
  final Color bgColor;
  final Color progressColor;
  final Color textColor;

  const EosProgressRow({
    super.key,
    required this.answeredCount,
    required this.totalQuestions,
    this.bgColor = LearningColors.windowsBackground,
    this.progressColor = const Color(0xFF388E3C),
    this.textColor = LearningColors.eosNavy,
  });

  @override
  State<EosProgressRow> createState() => _EosProgressRowState();
}

class _EosProgressRowState extends State<EosProgressRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int animationMs = 5000; // 10 giây: thời gian vệt sáng chạy
  final int delayMs = 10000; // 20 giây: thời gian nghỉ

  @override
  void initState() {
    super.initState();
    // Tổng thời gian là tổng của chạy + nghỉ
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationMs + delayMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double targetProgress = widget.totalQuestions > 0
        ? (widget.answeredCount / widget.totalQuestions).clamp(0.0, 1.0)
        : 0.0;

    final int percentage = (targetProgress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: widget.bgColor,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        children: [
          Text(
            "There are ${widget.totalQuestions} questions, and your progress is $percentage%",
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: targetProgress),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linear,
                  builder: (context, animatedProgress, child) {
                    final double progressWidth =
                        constraints.maxWidth * animatedProgress;

                    return Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade700),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: progressWidth,
                            color: widget.progressColor,
                          ),

                          if (animatedProgress > 0.01)
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                if (_controller.value > 0.4) {
                                  return const SizedBox.shrink();
                                }

                                // 1. Dùng constraints.maxWidth để tính toán tốc độ cố định
                                final double totalWidth = constraints.maxWidth;

                                // 2. Định nghĩa độ rộng vệt sáng cố định (ví dụ 25% của tổng chiều rộng hoặc một giá trị pixel cụ thể)
                                final double shineWidth = totalWidth * 0.25;

                                // 3. Map controller sang 0.0 -> 1.0 cho chu kỳ chạy
                                final shineProgress = _controller.value * 2.5;

                                // 4. Tính offset dựa trên totalWidth thay vì progressWidth
                                // Vệt sáng sẽ chạy từ trái sang phải trên toàn bộ chiều rộng thanh
                                final double offset =
                                    -shineWidth +
                                    (shineProgress * (totalWidth + shineWidth));

                                return Positioned(
                                  left: offset,
                                  top: 0,
                                  bottom: 0,
                                  width: shineWidth,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                                        colors: [
                                          Colors.white.withValues(alpha: 0.0),
                                          // Cạnh trái: trong suốt
                                          Colors.white.withValues(alpha: 0.1),
                                          // Dẫn vào vùng sáng: mờ nhẹ
                                          Colors.white.withValues(alpha: 0.6),
                                          // TRUNG TÂM: sáng nhất (glossy)
                                          Colors.white.withValues(alpha: 0.1),
                                          // Dẫn ra vùng tối: mờ nhẹ
                                          Colors.white.withValues(alpha: 0.0),
                                          // Cạnh phải: trong suốt
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
