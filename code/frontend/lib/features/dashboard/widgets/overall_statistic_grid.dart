import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/widgets/statistic_card.dart';

class OverallStatisticGrid extends StatelessWidget {
  final int totalQuestions;
  final int totalSeen;
  final double avgAccuracy;
  final int totalSessions;

  const OverallStatisticGrid({
    super.key,
    required this.totalQuestions,
    required this.totalSeen,
    required this.avgAccuracy,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 3,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        StatisticCard(
          label: "Tổng số câu",
          value: totalQuestions.toString(),
          icon: Icons.book_outlined,
          color: Colors.blue,
        ),
        StatisticCard(
          label: "Đã học",
          value: totalSeen.toString(),
          icon: Icons.check_circle_outline,
          color: Colors.orange,
        ),
        StatisticCard(
          label: "Chính xác",
          value: "${avgAccuracy.toStringAsFixed(1)}%",
          icon: Icons.track_changes,
          color: Colors.green,
        ),
        StatisticCard(
          label: "Phiên học",
          value: totalSessions.toString(),
          icon: Icons.history,
          color: Colors.purple,
        ),
      ],
    );
  }
}
