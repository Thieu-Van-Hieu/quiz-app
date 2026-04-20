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

    final localAnswers = useState<List<Answer>>([]);

    void startEditing() {
      contentController.text = question.content;
      explanationController.text = question.explanation;

      if (question.answers.isNotEmpty) {
        // NOTE: Tạo bản sao của danh sách đáp án để chỉnh sửa mà không ảnh hưởng đến dữ liệu gốc
        localAnswers.value = question.answers
            .map(
              (a) => Answer(
                content: a.content,
                isCorrect: a.isCorrect,
                indexOrder: a.indexOrder,
              )..id = a.id,
            )
            .toList();
      } else {
        localAnswers.value = [
          Answer(content: "", isCorrect: true),
          Answer(content: "", isCorrect: false),
        ];
      }
      isEditing.value = true;
    }

    useEffect(() {
      if (isEditing.value && localAnswers.value.isEmpty) {
        startEditing();
      }
      return null;
    }, []);

    // Hàm xử lý thay đổi thứ tự câu trả lời
    void onReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      // 1. Tạo danh sách mới để thay đổi thứ tự
      final newList = List<Answer>.from(localAnswers.value);
      final item = newList.removeAt(oldIndex);
      newList.insert(newIndex, item);

      // 2. CẬP NHẬT indexOrder cho TẤT CẢ các item trong list mới
      // Việc này rất quan trọng để khi hàm Save gọi, data đã sẵn sàng
      for (int i = 0; i < newList.length; i++) {
        newList[i].indexOrder = i;
      }

      // 3. Cập nhật state (đủ để UI render lại đúng thứ tự)
      localAnswers.value = newList;
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
            question.content = contentController.text.trim();
            question.explanation = explanationController.text.trim();
            question.answers.clear();
            question.answers.addAll(localAnswers.value);
            question.syncAnswers();
            onSave(question);
            isEditing.value = false;
          }),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                    // Phần Kéo thả câu trả lời
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: localAnswers.value.length,
                      onReorder: onReorder,
                      buildDefaultDragHandles: false,
                      // Tắt icon 2 gạch mặc định
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          type: MaterialType.transparency,
                          // Xóa màu nền tím/xám mặc định
                          child:
                              child, // Giữ nguyên style của AnswerItem khi đang kéo
                        );
                      },
                      itemBuilder: (context, i) {
                        final ans = localAnswers.value[i];
                        return AnswerItem(
                          // Quan trọng: Key giúp ReorderableListView xác định widget
                          key: ValueKey(ans.hashCode),
                          index: i,
                          initialValue: ans.content,
                          isCorrect: ans.isCorrect,
                          canDelete: localAnswers.value.length > 2,
                          onChanged: (val) {
                            ans.content = val;
                          },
                          onToggleCorrect: (val) {
                            final newList = List<Answer>.from(
                              localAnswers.value,
                            );
                            newList[i].isCorrect = val;
                            localAnswers.value = newList;
                          },
                          onDelete: () {
                            final newList = List<Answer>.from(
                              localAnswers.value,
                            )..removeAt(i);
                            localAnswers.value = newList;
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        localAnswers.value = [
                          ...localAnswers.value,
                          Answer(content: "", isCorrect: false),
                        ];
                      },
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
                    // View Mode
                    InkWell(
                      onDoubleTap: startEditing,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        width: double.infinity,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            question.content.isEmpty
                                ? LibraryStrings.noContent
                                : question.content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.toastText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...question.answers.map((ans) => _buildAnswerView(ans)),
                    if (question.explanation.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildExplanationView(),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS PHỤ ---

  Widget _buildAnswerView(Answer ans) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ans.isCorrect ? AppColors.successLight : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            ans.isCorrect ? Icons.check_circle : Icons.radio_button_off_rounded,
            size: 18,
            color: ans.isCorrect ? AppColors.success : AppColors.secondaryText,
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
  }

  Widget _buildExplanationView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.infoBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, size: 18, color: AppColors.infoBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              question.explanation,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ),
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
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      autofocus: autofocus,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        filled: true,
        fillColor: AppColors.textFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(Icons.edit, color: AppColors.infoBlue),
              ),
              IconButton(
                onPressed: onDelete,
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(Icons.delete, color: AppColors.toastError),
              ),
            ],
          )
        else
          Row(
            children: [
              TextButton(
                onPressed: () => isEditing.value = false,
                style: TextButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
                child: const Text(AppStrings.btnCancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSaveAction,
                style: ElevatedButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
                child: const Text(AppStrings.btnDone),
              ),
            ],
          ),
      ],
    );
  }
}
