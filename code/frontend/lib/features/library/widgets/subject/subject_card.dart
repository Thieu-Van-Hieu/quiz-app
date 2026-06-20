import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectCard({
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
                  // Gộp nhóm nút bấm sử dụng AppActionButton mới
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppActionButton(
                        actionType: ActionType.edit,
                        style: ActionButtonStyle
                            .tonal, // Nền mờ, chữ đậm pastel tinh tế
                        onTap: onEdit,
                      ),
                      const SizedBox(
                        width: 6,
                      ), // Khoảng cách nhẹ giữa 2 nút tròn
                      AppActionButton(
                        actionType: ActionType.delete,
                        style: ActionButtonStyle
                            .tonal, // Đồng bộ phong cách kẹo ngọt
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              // --- CONTENT: Code (Headline) & Name (Subtitle) ---
              Text(
                subject.code,
                style: const TextStyle(
                  color: LibraryColors.primaryText,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
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
