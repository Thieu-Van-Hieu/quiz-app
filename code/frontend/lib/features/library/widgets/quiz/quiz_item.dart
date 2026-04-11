import 'package:flutter/material.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLearn;
  final VoidCallback onExportJson;
  final VoidCallback onExportQuizlet;

  const QuizItem({
    super.key,
    required this.quiz,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onLearn,
    required this.onExportJson,
    required this.onExportQuizlet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      // Dùng Material để InkWell hiển thị hiệu ứng gợn sóng (ripple) chuẩn
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          hoverColor: Colors.transparent,
          // Bỏ màu nền khi di chuột qua
          splashColor: Colors.transparent,
          // Bỏ hiệu ứng gợn sóng khi click
          highlightColor: Colors.transparent,
          // Bỏ hiệu ứng đổi màu khi giữ chuột
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          // Chắc chắn bỏ mọi lớp phủ
          onTap: onTap,
          // InkWell tự xử lý cursor, không cần MouseRegion bao ngoài nữa
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HÀNG TRÊN: Icon mô tả & Các nút thao tác ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: LibraryColors.accentLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.description_rounded,
                        color: LibraryColors.quizIcon,
                        size: 22,
                      ),
                    ),
                    // Các IconButton bên trong vẫn sẽ có cursor riêng của chúng
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildExportMenu(),
                        _buildActionButton(
                          icon: Icons.school_outlined,
                          tooltip: "Bắt đầu học",
                          onPressed: onLearn,
                        ),
                        _buildActionButton(
                          icon: Icons.edit_note_rounded,
                          tooltip: "Sửa",
                          onPressed: onEdit,
                        ),
                        _buildActionButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: "Xóa",
                          onPressed: onDelete,
                          color: LibraryColors.deleteButton,
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

  // Helper để code gọn hơn và đảm bảo mọi nút đều có cursor click
  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color color = LibraryColors.accentColor,
  }) {
    return IconButton(
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(6),
      tooltip: tooltip,
      mouseCursor: SystemMouseCursors.click,
      icon: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildExportMenu() {
    return PopupMenuButton<int>(
      tooltip: "Xuất bộ đề",
      icon: const Icon(
        Icons.file_upload_outlined,
        color: LibraryColors.accentColor,
        size: 20,
      ),
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 0) onExportJson();
        if (value == 1) onExportQuizlet();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: ListTile(
            leading: Icon(Icons.data_object, size: 20),
            title: Text("Xuất file JSON"),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.content_paste_go_rounded, size: 20),
            title: Text("Copy cho Quizlet"),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }
}
