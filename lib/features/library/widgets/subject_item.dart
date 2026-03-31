import 'package:flutter/material.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';

class SubjectItem extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SubjectItem({
    super.key,
    required this.subject,
    required this.onTap,
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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.folder_rounded,
                    color: LibraryColors.folderIcon,
                    size: 28,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: LibraryColors.deleteButton,
                      size: 20,
                    ),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                subject.name,
                style: const TextStyle(
                  color: LibraryColors.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "${LibraryStrings.labelCode}${subject.code}",
                style: const TextStyle(
                  color: LibraryColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
