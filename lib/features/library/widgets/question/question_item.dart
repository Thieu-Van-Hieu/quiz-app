import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/widgets/question/answer_item.dart';

class QuestionItem extends HookWidget {
  final int index;
  final bool isNew;
  final Question question;
  final Function(Question) onSave;
  final VoidCallback onDelete;

  const QuestionItem({
    super.key,
    required this.index,
    this.isNew = false,
    required this.question,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = useState(question.content.isEmpty || isNew);
    final contentController = useTextEditingController(text: question.content);
    final explanationController = useTextEditingController(
      text: question.explanation,
    );

    final localAnswers = useState<List<Answer>>(
      question.answers.isNotEmpty
          ? question.answers.toList()
          : [
              Answer(content: "", isCorrect: true),
              Answer(content: "", isCorrect: false),
            ],
    );

    void startEditing() {
      contentController.text = question.content;
      explanationController.text = question.explanation;
      localAnswers.value = question.answers.toList();
      isEditing.value = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: isEditing.value
            ? Border.all(color: AppColors.infoBlue, width: 2)
            : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.toastShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isEditing, startEditing, () {
            final updatedQuestion = question.copyWith(
              content: contentController.text.trim(),
              explanation: explanationController.text.trim(),
            );
            updatedQuestion.answers.clear();
            updatedQuestion.answers.addAll(localAnswers.value);
            onSave(updatedQuestion);
            isEditing.value = false;
          }),
          const SizedBox(height: 16),
          if (isEditing.value) ...[
            _buildCustomTextField(
              controller: contentController,
              hintText: LibraryStrings.hintEnterQuestion,
              autofocus: question.content.isEmpty,
              isBold: true,
            ),
            const SizedBox(height: 12),
            _buildCustomTextField(
              controller: explanationController,
              hintText: "Add explanation (optional)...",
              fontSize: 14,
              maxLines: 2,
              prefixIcon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 20),
            ...localAnswers.value.asMap().entries.map((entry) {
              final i = entry.key;
              final ans = entry.value;
              return AnswerItem(
                index: i,
                initialValue: ans.content,
                isCorrect: ans.isCorrect,
                canDelete: localAnswers.value.length > 2,
                onChanged: (val) {
                  localAnswers.value[i] = localAnswers.value[i].copyWith(
                    content: val,
                  );
                },
                onToggleCorrect: (val) {
                  final newList = List<Answer>.from(localAnswers.value);
                  newList[i] = newList[i].copyWith(isCorrect: val);
                  localAnswers.value = newList;
                },
                onDelete: () {
                  final newList = List<Answer>.from(localAnswers.value)
                    ..removeAt(i);
                  localAnswers.value = newList;
                },
              );
            }),
            TextButton.icon(
              onPressed: () {
                localAnswers.value = [
                  ...localAnswers.value,
                  Answer(content: "", isCorrect: false),
                ];
              },
              style: TextButton.styleFrom(
                enabledMouseCursor: SystemMouseCursors.click,
              ),
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.infoBlue,
              ),
              label: const Text(
                LibraryStrings.btnAddOption,
                style: TextStyle(color: AppColors.infoBlue),
              ),
            ),
          ] else ...[
            InkWell(
              onDoubleTap: startEditing,
              borderRadius: BorderRadius.circular(8),
              // InkWell mặc định có cursor bàn tay, không cần MouseRegion
              child: Text(
                question.content.isEmpty
                    ? LibraryStrings.noContent
                    : question.content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: AppColors.toastText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...question.answers.map((ans) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ans.isCorrect
                      ? AppColors.successLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      ans.isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_off_rounded,
                      size: 18,
                      color: ans.isCorrect
                          ? AppColors.success
                          : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ans.content,
                        style: const TextStyle(color: AppColors.toastText),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (question.explanation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.infoBlue.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb,
                      size: 18,
                      color: AppColors.infoBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question.explanation,
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    bool autofocus = false,
    bool isBold = false,
    double fontSize = 16,
    int maxLines = 2,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        fontSize: fontSize,
        color: AppColors.toastText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: AppColors.secondaryText)
            : null,
        hintStyle: const TextStyle(color: AppColors.secondaryText),
        filled: true,
        fillColor: AppColors.textFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildHeader(
    ValueNotifier<bool> isEditing,
    VoidCallback onEdit,
    VoidCallback onSaveAction,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${LibraryStrings.labelQuestionNumber} $index",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.infoBlue,
          ),
        ),
        if (!isEditing.value)
          Row(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.infoBlue,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.toastError,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              TextButton(
                onPressed: () {
                  if (question.content.isEmpty && isNew) {
                    onDelete();
                  } else {
                    isEditing.value = false;
                  }
                },
                style: TextButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
                child: const Text(AppStrings.btnCancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSaveAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  enabledMouseCursor: SystemMouseCursors.click,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(AppStrings.btnDone),
              ),
            ],
          ),
      ],
    );
  }
}
