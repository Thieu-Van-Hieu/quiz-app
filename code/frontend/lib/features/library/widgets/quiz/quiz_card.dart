import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
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

  // --- HÀM HELPER HIỂN THỊ MENU EXPORT CHUẨN TỌA ĐỘ BẬT TỪ APP_ACTION_BUTTON ---
  void _showExportMenu(BuildContext context, BuildContext buttonContext) {
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(0, button.size.height + 6),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      elevation: 0,
      color: Colors.white,
      constraints: const BoxConstraints(minWidth: 180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 2.0),
      ),
      items: [
        const PopupMenuItem(
          value: 0,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.data_object_rounded, size: 18),
            title: Text(
              "Xuất file JSON",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.content_paste_go_rounded, size: 18),
            title: Text(
              "Copy cho Quizlet",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;
      if (value == 0) onExportJson();
      if (value == 1) onExportQuizlet();
    });
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
                        // 1. NÚT XUẤT BỘ ĐỀ (Bọc Builder để tính tọa độ menu thả xuống chuẩn pixel)
                        Builder(
                          builder: (buttonContext) {
                            return AppActionButton(
                              icon: Icons.file_upload_outlined,
                              tooltip: "Xuất bộ đề",
                              onTap: () =>
                                  _showExportMenu(context, buttonContext),
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
