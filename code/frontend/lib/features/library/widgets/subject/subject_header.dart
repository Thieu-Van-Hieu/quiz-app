import 'package:flutter/material.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/search_params/subject_search_params.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:frontend/features/library/widgets/subject/add_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectHeader extends ConsumerWidget {
  final SubjectSearchParams params;
  final VoidCallback? onAddSuccess;

  const SubjectHeader({super.key, required this.params, this.onAddSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LibraryStrings.title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: LibraryColors.primaryText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              LibraryStrings.subtitle,
              style: TextStyle(
                color: LibraryColors.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddDialog(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            LibraryStrings.btnAdd,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddSubjectDialog(
        onSave: (name, code) async {
          final newSubject = Subject(code: code, name: name);
          await ref
              .read(subjectProvider(params).notifier)
              .saveSubject(newSubject)
              .withToast(context);

          // Sau khi lưu xong, gọi callback thông báo cho SubjectPage
          if (context.mounted) {
            onAddSuccess?.call();
          }
        },
      ),
    );
  }
}
