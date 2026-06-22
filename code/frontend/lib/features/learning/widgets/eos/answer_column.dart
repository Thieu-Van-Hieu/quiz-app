import 'package:flutter/cupertino.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/learning/utils/learning_utils.dart';
import 'package:frontend/features/learning/widgets/retro/checkbox.dart';
import 'package:frontend/features/library/models/answer.dart';

class EosAnswerColumn extends StatelessWidget {
  final LearningSessionDetail learningSessionDetail;
  final Function(Answer answer) onAnswerSelected;
  final List<Widget> actions;

  const EosAnswerColumn({
    super.key,
    required this.learningSessionDetail,
    required this.onAnswerSelected,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final question = learningSessionDetail.question.target;
    if (question == null) return const SizedBox.shrink();

    // =========================================================================
    // XỬ LÝ SHUFFLE ĐÁP ÁN QUA UTILS (ĐỒNG BỘ ĐỘC LẬP VỚI CONTENT)
    // =========================================================================
    final session = learningSessionDetail.learningSession.target;

    final displayAnswers = LearningUtils.getShuffledAnswers(
      session: session,
      questionId: question.id,
      originalAnswers: question.answers,
    );
    // =========================================================================

    final currentSelected = learningSessionDetail.selectedAnswers.toList();

    // Tìm index chính xác dựa trên ID trong danh sách ĐÃ TRỘN
    final selectedIndices = currentSelected
        .map((selected) {
          return displayAnswers.indexWhere((ans) => ans.id == selected.id);
        })
        .where((index) => index != -1)
        .toList();

    final isLocked = learningSessionDetail.isChecked;
    return Container(
      width: 180,
      color: LearningColors.windowsBackground,
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            "Answer",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: LearningColors.eosPrimaryBlue,
            ),
          ),
          const SizedBox(height: 15),

          // Render Options dựa theo displayAnswers đã xử lý hoán vị
          ...List.generate(displayAnswers.length, (index) {
            final isSelected = selectedIndices.contains(index);
            final currentAnswer =
                displayAnswers[index]; // Lấy đúng đáp án theo vị trí trộn mới
            final isCorrect = currentAnswer.isCorrect;

            // Tính toán màu sắc dựa trên vị trí hiển thị mới
            Color? feedbackColor;
            if (isLocked) {
              if (isCorrect) {
                feedbackColor = LearningColors.correct;
              } else if (isSelected) {
                feedbackColor = LearningColors.wrong;
              }
            }

            return RetroCheckbox(
              label: String.fromCharCode(65 + index),
              value: isSelected,
              onChanged: (_) => {
                if (!isLocked) {onAnswerSelected(currentAnswer)},
              },
              color: feedbackColor,
            );
          }),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: actions),
          ),
        ],
      ),
    );
  }
}
