import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:frontend/features/library/widgets/add_subject_dialog.dart';
import 'package:frontend/features/library/widgets/subject_item.dart';
import 'package:frontend/features/library/widgets/subject_search.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends HookConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');
    final subjectsAsync = ref.watch(subjectNotifierProvider);

    return Scaffold(
      backgroundColor: LibraryColors.background,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SECTION ---
            _buildHeader(context, ref),
            const SizedBox(height: 40),

            // --- SEARCH SECTION ---
            SubjectSearch(onSearch: (v) => searchQuery.value = v),
            const SizedBox(height: 32),

            // --- CONTENT SECTION ---
            Expanded(
              child: subjectsAsync.when(
                data: (list) {
                  final filtered = list
                      .where(
                        (s) =>
                            s.name.toLowerCase().contains(
                              searchQuery.value.toLowerCase(),
                            ) ||
                            s.code.toLowerCase().contains(
                              searchQuery.value.toLowerCase(),
                            ),
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text(LibraryStrings.emptyList));
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisExtent: 180,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => SubjectItem(
                      subject: filtered[index],
                      onTap: () =>
                          context.go('/library/courses/${filtered[index].id}'),
                      onDelete: () =>
                          _confirmDelete(context, ref, filtered[index]),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PRIVATE UI HELPER ---
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
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
            elevation: 0,
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

  // --- LOGIC DIALOGS ---
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) =>
          const AddSubjectDialog(), // Widget dialog này cũng nên tách file nếu cần
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(LibraryStrings.deleteConfirmTitle),
        content: Text(
          "${LibraryStrings.deleteConfirmContent}\n(${subject.name})",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(LibraryStrings.btnCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LibraryColors.deleteButton,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ref
                  .read(subjectNotifierProvider.notifier)
                  .deleteSubject(subject.id);
              Navigator.pop(context);
            },
            child: const Text(LibraryStrings.btnDelete),
          ),
        ],
      ),
    );
  }
}
