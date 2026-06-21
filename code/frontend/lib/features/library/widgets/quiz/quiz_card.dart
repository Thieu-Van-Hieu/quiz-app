import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/input/menu.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLearn;
  final VoidCallback onExportJson;
  final VoidCallback onExportQuizlet;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onLearn,
    required this.onExportJson,
    required this.onExportQuizlet,
  });

  void _handleExportMenu(
    BuildContext context,
    BuildContext buttonContext,
  ) async {
    final selectedValue = await AppMenu.show(
      context: context,
      buttonContext: buttonContext,
      offsetTop: 8.0, // Khoảng cách cách nút hành động nhỏ 8px
      items: const [
        AppMenuItem(
          value: 0,
          label: "Xuất file JSON",
          icon: Icons.data_object_rounded,
        ),
        AppMenuItem(
          value: 1,
          label: "Copy cho Quizlet",
          icon: Icons.content_paste_go_rounded,
        ),
      ],
    );

    if (selectedValue == null) return;
    if (selectedValue == 0) onExportJson();
    if (selectedValue == 1) onExportQuizlet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Đồng bộ hiệu ứng khối nổi cho chính chiếc Card theo vibe chung của app
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: LibraryColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HÀNG TRÊN: Icon mô tả & Toàn bộ hệ thống AppActionButton 3D ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.description_rounded,
                      color: LibraryColors.quizIcon,
                      size: 22,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. NÚT XUẤT BỘ ĐỀ (Bọc bằng AppMenu mới để quản lý dropdown an toàn)
                        Builder(
                          builder: (buttonContext) {
                            return AppActionButton(
                              icon: Icons.file_upload_outlined,
                              tooltip: "Xuất bộ đề",
                              onTap: () => _handleExportMenu(
                                context,
                                buttonContext,
                              ), // Nút nhận function đầy đủ, sáng bừng và giữ nguyên hiệu ứng bấm
                              actionType: ActionType.export,
                            );
                          },
                        ),

                        const SizedBox(width: 8),

                        // 2. NÚT BẮT ĐẦU HỌC
                        AppActionButton(
                          icon: Icons.school_outlined,
                          tooltip: "Bắt đầu học",
                          onTap: onLearn,
                          actionType: ActionType.info,
                        ),
                        const SizedBox(width: 8),

                        // 3. NÚT SỬA BỘ ĐỀ
                        AppActionButton(
                          icon: Icons.edit_note_rounded,
                          tooltip: "Sửa",
                          onTap: onEdit,
                          actionType: ActionType.edit,
                        ),
                        const SizedBox(width: 8),

                        // 4. NÚT XÓA (Truyền màu Danger/Delete đặc thù của hệ thống)
                        AppActionButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: "Xóa",
                          onTap: onDelete,
                          actionType: ActionType.delete,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- NỘI DUNG: Tên bộ đề ---
                Text(
                  quiz.name,
                  style: const TextStyle(
                    color: LibraryColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      size: 14,
                      color: LibraryColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${quiz.questions.length} ${LibraryStrings.labelQuestions}",
                      style: const TextStyle(
                        color: LibraryColors.secondaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
