import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/widgets/subject/add_dialog.dart';
import 'package:frontend/features/library/widgets/delete_confirm_dialog.dart';
import 'package:frontend/features/library/widgets/subject/subject_item.dart';
import 'package:frontend/features/library/widgets/subject/update_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubjectPage extends HookConsumerWidget {
  const SubjectPage({super.key});

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
            AppSearchBar(onSearch: (v) => searchQuery.value = v),
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
                      onTap: () => context.go(
                        LibraryRoutes.getSubjectDetailPath(filtered[index].id),
                      ),
                      onEdit: () => _showUpdateSubjectDialog(
                        context,
                        ref,
                        filtered[index],
                      ),
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
            enabledMouseCursor: SystemMouseCursors.click,
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
      builder: (context) => AddSubjectDialog(
        onSave: (name, code) {
          final newSubject = Subject()
            ..code = code
            ..name = name;
          ref
              .read(subjectNotifierProvider.notifier)
              .saveSubject(newSubject)
              .withToast(context);
        },
      ),
    );
  }

  void _showUpdateSubjectDialog(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => UpdateSubjectDialog(
        subject: subject,
        onUpdate: (newName, newCode) {
          subject.name = newName;
          subject.code = newCode;
          // Gọi hàm update có validate trong notifier
          ref
              .read(subjectNotifierProvider.notifier)
              .saveSubject(subject)
              .withToast(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Subject subject) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        itemName: subject.name,
        onDelete: () {
          ref
              .read(subjectNotifierProvider.notifier)
              .deleteSubject(subject.id)
              .withToast(context);
        },
      ),
    );
  }
}
