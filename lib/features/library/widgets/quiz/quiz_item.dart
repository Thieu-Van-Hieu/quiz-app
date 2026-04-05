import 'package:flutter/material.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuizItem({
    super.key,
    required this.quiz,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
      // Bọc MouseRegion bên ngoài cùng để đảm bảo toàn bộ card đều đổi cursor
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onEdit,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          tooltip: "Sửa", // Thêm tooltip để thân thiện hơn
                          icon: const Icon(
                            Icons.edit_note_rounded,
                            color: LibraryColors.accentColor,
                            size: 22,
                          ),
                          // IconButton trong Flutter mặc định đã là click cursor,
                          // nhưng khai báo lại cho chắc chắn.
                          mouseCursor: SystemMouseCursors.click,
                        ),
                        IconButton(
                          onPressed: onDelete,
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          tooltip: "Xóa",
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: LibraryColors.deleteButton,
                            size: 20,
                          ),
                          mouseCursor: SystemMouseCursors.click,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- NỘI DUNG: Tên bộ đề & Số lượng câu hỏi ---
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
