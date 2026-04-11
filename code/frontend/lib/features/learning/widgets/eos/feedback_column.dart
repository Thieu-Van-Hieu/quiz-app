import 'package:flutter/material.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/learning/widgets/eos/header_info.dart';

class EosFeedbackColumn extends StatelessWidget {
  final double width;
  final LearningSessionDetail learningSessionDetail;

  const EosFeedbackColumn({
    super.key,
    required this.width,
    required this.learningSessionDetail,
  });

  @override
  Widget build(BuildContext context) {
    final question = learningSessionDetail.question.target;
    // Dùng detail để truy cập ngược lại session cha
    final session = learningSessionDetail.learningSession.target;

    if (question == null || session == null) {
      return SizedBox(
        width: width,
        child: const Center(child: Text("No Data")),
      );
    }

    final String mode = session.learningMode.toUpperCase();
    final bool isStudyMode = mode == 'STUDY';
    final bool isExamMode = mode == 'EXAM' || mode == 'LEARNING';

    // 1. Số đáp án đúng
    final correctAnswersCount = question.answers
        .where((a) => a.isCorrect)
        .length;

    // 2. Logic hiển thị Feedback Icon (Dùng trạng thái isChecked của detail)
    bool shouldShowFeedback = false;
    if (isStudyMode && learningSessionDetail.isChecked) {
      shouldShowFeedback = true;
    } else if (isExamMode && session.isCompleted) {
      shouldShowFeedback = true;
    }

    // 3. Logic hiển thị Stats
    bool shouldShowStats = isStudyMode || (isExamMode && session.isCompleted);

    final currentCorrect = session.learningSessionDetails
        .where((d) => d.isCorrect == true)
        .length;
    final currentWrong = session.learningSessionDetails
        .where((d) => d.isChecked && d.isCorrect == false)
        .length;

    return Container(
      width: width,
      color: LearningColors.windowsWhite,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Column(
        children: [
          Text(
            '(Choose $correctAnswersCount answer${correctAnswersCount > 1 ? 's' : ''})',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // FEEDBACK AREA: Sẽ tự động hiện khi isChecked = true nhờ build() lại StudyPage
          if (shouldShowFeedback) ...[
            if (learningSessionDetail.isCorrect != null) ...[
              Icon(
                learningSessionDetail.isCorrect!
                    ? Icons.check_circle
                    : Icons.cancel,
                size: 60,
                color: learningSessionDetail.isCorrect!
                    ? LearningColors.correct
                    : LearningColors.wrong,
              ),
              const SizedBox(height: 8),
              Text(
                learningSessionDetail.isCorrect! ? "CORRECT" : "WRONG",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: learningSessionDetail.isCorrect!
                      ? LearningColors.correct
                      : LearningColors.wrong,
                ),
              ),
            ],
          ],

          const Spacer(),

          if (shouldShowStats) ...[
            HeaderInfo(
              label: "Correct:",
              value: "$currentCorrect", // Dùng biến vừa tính
              color: LearningColors.correct,
            ),
            HeaderInfo(
              label: "Wrong:",
              value: "$currentWrong", // Dùng biến vừa tính
              color: LearningColors.wrong,
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
