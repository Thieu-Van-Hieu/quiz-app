import 'package:flutter/material.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';

class SessionQuestionCard extends StatelessWidget {
  final LearningSessionDetail detail;
  final LearningMode mode;
  final VoidCallback onTap;

  const SessionQuestionCard({
    super.key,
    required this.detail,
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final question = detail.question.target;
    final isPractice = mode == LearningMode.practice;

    IconData icon;
    Color color;
    if (isPractice) {
      icon = detail.isSeen ? Icons.visibility : Icons.visibility_off;
      color = detail.isSeen ? Colors.orange : Colors.grey.shade400;
    } else {
      icon = detail.isCorrect == true ? Icons.check_circle : Icons.cancel;
      color = detail.isCorrect == true ? Colors.green : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          question?.content ?? "N/A",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}
