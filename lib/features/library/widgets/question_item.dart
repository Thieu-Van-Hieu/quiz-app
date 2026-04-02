import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/widgets/option_item.dart';

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
    final isEditing = useState(question.content.isEmpty);
    final contentController = useTextEditingController(text: question.content);
    // 1. Thêm controller cho Explanation
    final explanationController = useTextEditingController(
      text: question.explanation,
    );

    final options = useState<List<String>>(List.from(question.options));
    final correctIndices = useState<List<int>>(
      List.from(question.correctOptions),
    );

    void startEditing() {
      contentController.text = question.content;
      explanationController.text = question.explanation; // Xử lý optional
      options.value = List.from(question.options);
      correctIndices.value = List.from(question.correctOptions);
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
          // --- HEADER ---
          _buildHeader(isEditing, startEditing, () {
            question.content = contentController.text.trim();
            // 2. Lưu explanation vào model
            question.explanation = explanationController.text.trim();
            question.options = List.from(options.value);
            question.correctOptions = List.from(correctIndices.value);

            onSave(question);
            isEditing.value = false;
          }),

          const SizedBox(height: 16),

          if (isEditing.value) ...[
            // --- EDIT MODE: Content ---
            _buildCustomTextField(
              controller: contentController,
              hintText: LibraryStrings.hintEnterQuestion,
              autofocus: question.content.isEmpty,
              isBold: true,
            ),

            const SizedBox(height: 12),

            // --- EDIT MODE: Explanation (Optional) ---
            _buildCustomTextField(
              controller: explanationController,
              hintText: "Add explanation (optional)...",
              fontSize: 14,
              maxLines: 2,
              prefixIcon: Icons.lightbulb_outline,
            ),

            const SizedBox(height: 20),

            ...List.generate(options.value.length, (i) {
              return OptionItem(
                index: i,
                initialValue: options.value[i],
                isCorrect: correctIndices.value.contains(i),
                canDelete: options.value.length > 2,
                onChanged: (val) {
                  final newList = List<String>.from(options.value);
                  newList[i] = val;
                  options.value = newList;
                },
                onToggleCorrect: (val) {
                  if (val) {
                    correctIndices.value = [...correctIndices.value, i];
                  } else {
                    correctIndices.value = correctIndices.value
                        .where((idx) => idx != i)
                        .toList();
                  }
                },
                onDelete: () {
                  final newList = List<String>.from(options.value)..removeAt(i);
                  options.value = newList;
                  correctIndices.value = correctIndices.value
                      .where((idx) => idx != i)
                      .map((idx) => idx > i ? idx - 1 : idx)
                      .toList();
                },
              );
            }),
            TextButton.icon(
              onPressed: () => options.value = [...options.value, ""],
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
            // --- VIEW MODE: Content ---
            InkWell(
              onDoubleTap: startEditing,
              borderRadius: BorderRadius.circular(8),
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

            // --- VIEW MODE: Options ---
            ...List.generate(question.options.length, (i) {
              final isCorrect = question.correctOptions.contains(i);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.successLight
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_off_rounded,
                      size: 18,
                      color: isCorrect
                          ? AppColors.success
                          : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.options[i],
                        style: const TextStyle(color: AppColors.toastText),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // --- VIEW MODE: Explanation (Chỉ hiện nếu có data) ---
            if (question.explanation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.infoBlue.withOpacity(0.1),
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

  // Widget phụ để build TextField cho gọn
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
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.toastError,
                  size: 20,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              TextButton(
                onPressed: () {
                  if (question.content.isEmpty) {
                    onDelete();
                  } else {
                    isEditing.value = false;
                  }
                },
                child: const Text(AppStrings.btnCancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSaveAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
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
