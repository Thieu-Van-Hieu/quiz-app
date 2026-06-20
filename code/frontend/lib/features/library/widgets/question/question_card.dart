import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/widgets/question/answer_card.dart';

class QuestionCard extends HookWidget {
  final int index;
  final bool isNew;
  final Question question;
  final Function(Question) onSave;
  final VoidCallback onDelete;

  const QuestionCard({
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

    void onReorder(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final newList = List<Answer>.from(localAnswers.value);
      final item = newList.removeAt(oldIndex);
      newList.insert(newIndex, item);

      for (int i = 0; i < newList.length; i++) {
        newList[i].indexOrder = i;
      }

      localAnswers.value = newList;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: isEditing.value
            ? Border.all(color: LibraryColors.editBorder, width: 2.5)
            : null,
        boxShadow: const [
          BoxShadow(
            color: LibraryColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      // ✅ GIẢI PHÁP: Sử dụng SingleChildScrollView bọc ngoài Column nội dung chính
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER CARD ---
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

            // --- BODY NỘI DUNG THAY ĐỔI THEO TRẠNG THÁI ---
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
                hintText: "Thêm giải thích (không bắt buộc)...",
                fontSize: 14,
                maxLines: 2,
                prefixIcon: Icons.lightbulb_outline_rounded,
              ),
              const SizedBox(height: 20),

              ReorderableListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Vô hiệu hóa scroll riêng của List kéo thả để dùng chung trục scroll cha
                itemCount: localAnswers.value.length,
                onReorder: onReorder,
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) {
                  return Material(
                    type: MaterialType.transparency,
                    child: child,
                  );
                },
                itemBuilder: (context, i) {
                  final ans = localAnswers.value[i];
                  return AnswerCard(
                    key: ValueKey(ans.hashCode),
                    index: i,
                    initialValue: ans.content,
                    isCorrect: ans.isCorrect,
                    canDelete: localAnswers.value.length > 2,
                    onChanged: (val) {
                      ans.content = val;
                    },
                    onToggleCorrect: (val) {
                      final newList = List<Answer>.from(localAnswers.value);
                      newList[i].isCorrect = val;
                      localAnswers.value = newList;
                    },
                    onDelete: () {
                      final newList = List<Answer>.from(localAnswers.value)
                        ..removeAt(i);
                      localAnswers.value = newList;
                    },
                  );
                },
              ),

              const SizedBox(height: 12),
              AppButton(
                onPressed: () {
                  localAnswers.value = [
                    ...localAnswers.value,
                    Answer(content: "", isCorrect: false),
                  ];
                },
                icon: Icons.add_circle_outline_rounded,
                label: LibraryStrings.btnAddOption,
                variant: ButtonVariant.brandOutlined,
                size: ButtonSize.small,
              ),
            ] else ...[
              // --- CHẾ ĐỘ XEM TRỰC QUAN (VIEW MODE) ---
              InkWell(
                onDoubleTap: startEditing,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    question.content.isEmpty
                        ? LibraryStrings.noContent
                        : question.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LibraryColors.primaryText,
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
    );
  }

  // --- CÁC WIDGET THÀNH PHẦN PHỤ ---

  Widget _buildAnswerView(Answer ans) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        // Thay đổi màu nền: Đáp án đúng dùng màu lục trong trẻo, đáp án thường dùng màu trắng tinh để không bị đì nền
        color: ans.isCorrect ? LibraryColors.correctBackground : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ans.isCorrect
              ? LibraryColors.correct.withValues(
                  alpha: 0.6,
                ) // Tăng nhẹ alpha cho viền xanh sắc nét
              : const Color(0xFFE2E8F0).withValues(
                  alpha: 0.7,
                ), // Làm dịu viền xám để tiệp vào background tổng thể
          width: ans.isCorrect
              ? 1.5
              : 1.2, // Đáp án thường dùng viền mảnh hơn để tăng độ thanh thoát
        ),
        // Thêm chút shadow cực nhẹ cho đáp án thường để nổi bật trên nền layout tổng thể
        boxShadow: !ans.isCorrect
            ? [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            ans.isCorrect
                ? Icons.check_circle_rounded
                : Icons.radio_button_off_rounded,
            size: 20,
            color: ans.isCorrect
                ? LibraryColors.correct
                : const Color(
                    0xFF94A3B8,
                  ), // Đổi màu icon rỗng sang màu Slate nhẹ nhàng, không bị tối cũ kỹ
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ans.content,
              style: TextStyle(
                color: ans.isCorrect
                    ? LibraryColors.primaryText
                    : const Color(
                        0xFF334155,
                      ), // Màu chữ xám Slate đậm giúp đọc rõ chữ và không bị đì tương phản
                fontWeight: FontWeight.w500,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationView() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCFCE7), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            size: 20,
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              question.explanation,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
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
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        fontSize: fontSize,
        color: LibraryColors.primaryText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: LibraryColors.disabledText),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: LibraryColors.secondaryText)
            : null,
        filled: true,
        fillColor: LibraryColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
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
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Color(0xFF93C5FD),
            letterSpacing: 0.3,
          ),
        ),
        if (!isEditing.value)
          Row(
            children: [
              AppActionButton(
                onTap: onEdit,
                actionType: ActionType.edit,
                style: ActionButtonStyle.tonal,
                tooltip: "Chỉnh sửa câu hỏi",
              ),
              const SizedBox(width: 8),
              AppActionButton(
                onTap: onDelete,
                actionType: ActionType.delete,
                style: ActionButtonStyle.tonal,
                tooltip: "Xóa câu hỏi",
              ),
            ],
          )
        else
          Row(
            children: [
              AppButton(
                onPressed: () {
                  if (question.isDraft) {
                    onDelete();
                  } else {
                    isEditing.value = false;
                  }
                },
                label: AppStrings.btnCancel,
                variant: ButtonVariant.slateOutlined,
                size: ButtonSize.small,
              ),
              const SizedBox(width: 8),
              AppButton(
                onPressed: () {
                  if (question.isDraft) {
                    question.setAsNew();
                  }
                  onSaveAction();
                },
                label: AppStrings.btnDone,
                variant: ButtonVariant.brand,
                size: ButtonSize.small,
              ),
            ],
          ),
      ],
    );
  }
}
