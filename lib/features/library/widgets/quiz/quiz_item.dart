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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground, // Dùng màu card của phen
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: LibraryColors.shadow, // Bóng đổ siêu mờ
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Icon bộ đề dùng màu accent xanh dương hiện đại
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: LibraryColors.accentLight, // Đã tách vào colors
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: LibraryColors.quizIcon, // Đã tách vào colors
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.name,
                      style: const TextStyle(
                        color: LibraryColors.primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${quiz.questions?.length ?? 0} ${LibraryStrings.labelQuestions}", // Đã tách vào strings
                      style: const TextStyle(
                        color: LibraryColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    color: LibraryColors.folderIcon,
                    size: 28,
                  ),
                  // Gộp nhóm nút bấm lại một cụm
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        constraints:
                            const BoxConstraints(), // Thu gọn padding mặc định
                        padding: const EdgeInsets.all(8),
                        icon: const Icon(
                          Icons.edit_note_rounded,
                          color: LibraryColors.accentColor,
                          size: 22,
                        ),
                        mouseCursor: SystemMouseCursors.click,
                      ),
                      IconButton(
                        onPressed: onDelete,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
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
            ],
          ),
        ),
      ),
    );
  }
}
