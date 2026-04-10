// lib/features/learning/widgets/eos_side_control.dart
import 'package:flutter/cupertino.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
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
    final question = learningSessionDetail.question.target!;

    // 1. Ép load lại list từ DB
    final allAnswers = question.answers.toList();
    final currentSelected = learningSessionDetail.selectedAnswers.toList();

    // 2. Tìm index dựa trên ID thay vì so sánh Object trực tiếp
    final selectedIndices = currentSelected
        .map((selected) {
          return allAnswers.indexWhere((ans) => ans.id == selected.id);
        })
        .where((index) => index != -1)
        .toList(); // Lọc bỏ các giá trị -1 nếu có lỗi data

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

          // Render Options
          ...List.generate(question.answers.length, (index) {
            final isSelected = selectedIndices.contains(index);
            final isCorrect = question.answers.toList()[index].isCorrect;

            // Chỉ tính toán màu khi bị khóa (đã Check)
            Color? feedbackColor;
            if (isLocked) {
              if (isCorrect) {
                feedbackColor = LearningColors.correct;
              } else if (isSelected) {
                feedbackColor = LearningColors.wrong;
              }
            }

            return EosRetroCheckbox(
              label: String.fromCharCode(65 + index),
              value: isSelected,
              // Nếu bị khóa thì onChanged là null -> Checkbox sẽ disabled
              onChanged: (_) => {
                if (!isLocked)
                  {onAnswerSelected(question.answers.toList()[index])},
              },
              color: feedbackColor,
            );
          }),

          const Spacer(),
          // Page muốn hiện nút gì thì cứ ném vào đây
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: actions),
          ),
        ],
      ),
    );
  }
}
