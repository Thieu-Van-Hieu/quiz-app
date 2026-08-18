import 'package:flutter/material.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/pages/learning_session_detail_page.dart';
import 'package:frontend/features/learning/widgets/learning_session_detail/statistic_box.dart';
import 'package:intl/intl.dart';

class SessionHeaderStatistic extends StatelessWidget {
  final LearningSession session;
  final SessionFilter currentFilter;
  final Function(SessionFilter) onFilterChanged;

  const SessionHeaderStatistic({
    super.key,
    required this.session,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.quiz.target?.name ?? "Bộ đề",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "Đã học: ${DateFormat('dd/MM HH:mm').format(session.startTime)}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              StatisticBox(
                label: "TỔNG CÂU",
                value: "${session.learningSessionDetails.length}",
                color: Colors.blue,
                isSelected: currentFilter == SessionFilter.all,
                onTap: () => onFilterChanged(SessionFilter.all),
              ),
              const SizedBox(width: 12),

              ...[
                StatisticBox(
                  label: "ĐÃ QUA",
                  value: "${session.totalPass}",
                  color: Colors.green,
                  isSelected: currentFilter == SessionFilter.pass,
                  onTap: () => onFilterChanged(SessionFilter.pass),
                ),
                const SizedBox(width: 12),
                StatisticBox(
                  label: "CHƯA QUA",
                  value: "${session.totalNotPass}",
                  color: Colors.red,
                  isSelected: currentFilter == SessionFilter.notPass,
                  onTap: () => onFilterChanged(SessionFilter.notPass),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
