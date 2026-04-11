import 'package:flutter/material.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/subject.dart';

class SubjectItem extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectItem({
    super.key,
    required this.subject,
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
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP ROW: Icon & Action Buttons ---
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
              const Spacer(),

              // --- CONTENT: Code (Headline) & Name (Subtitle) ---
              // 1. Mã môn học làm tiêu đề chính
              Text(
                subject.code.toUpperCase(),
                style: const TextStyle(
                  color: LibraryColors.primaryText,
                  fontWeight: FontWeight.w900, // Đậm hơn để nổi bật
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // 2. Tên môn học cho xuống dưới làm phụ đề
              Text(
                subject.name,
                style: const TextStyle(
                  color: LibraryColors.secondaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
