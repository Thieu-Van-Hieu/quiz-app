import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/core/widgets/pagination.dart'; // Import Widget phân trang của bạn
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/models/search_params/subject_search_params.dart';
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
    // 1. Khởi tạo Params (Mặc định trang 0, mỗi trang 12 môn)
    final params = useState(SubjectSearchParams(size: 12, page: 0));

    // 2. Watch data theo params hiện tại
    final subjectsAsync = ref.watch(subjectProvider(params.value));
    final totalPagesAsync = ref.watch(subjectTotalPagesProvider(params.value));

    return Scaffold(
      backgroundColor: LibraryColors.background,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref, params.value),
            const SizedBox(height: 40),

            // 3. Search Bar: Khi gõ sẽ cập nhật keyword và reset về trang đầu tiên
            AppSearchBar(
              onSearch: (v) =>
                  params.value = params.value.copyWith(keyword: v, page: 0),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: subjectsAsync.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text(LibraryStrings.emptyList));
                  }

                  return Column(
                    children: [
                      // GRID DANH SÁCH
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                mainAxisExtent: 180,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                              ),
                          itemCount: list.length,
                          itemBuilder: (context, index) => SubjectItem(
                            subject: list[index],
                            onTap: () => context.go(
                              LibraryRoutes.getSubjectDetailPath(
                                list[index].id,
                              ),
                            ),
                            onEdit: () => _showUpdateDialog(
                              context,
                              ref,
                              list[index],
                              params.value,
                            ),
                            onDelete: () => _confirmDelete(
                              context,
                              ref,
                              list[index],
                              params.value,
                            ),
                          ),
                        ),
                      ),

                      // THANH PHÂN TRANG (PAGINATION)
                      const SizedBox(height: 24),
                      totalPagesAsync.maybeWhen(
                        data: (total) => AppPagination(
                          currentPage: params.value.page,
                          totalPages: total,
                          activeColor: LibraryColors.accentColor,
                          onPageChange: (newPage) {
                            params.value = params.value.copyWith(page: newPage);
                          },
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
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

  // --- PRIVATE UI HELPERS & LOGIC DIALOGS ---

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    SubjectSearchParams currentParams,
  ) {
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
          onPressed: () => _showAddDialog(context, ref, currentParams),
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

  void _showAddDialog(
    BuildContext context,
    WidgetRef ref,
    SubjectSearchParams currentParams,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddSubjectDialog(
        onSave: (name, code) {
          final newSubject = Subject(code: code, name: name);
          ref
              .read(subjectProvider(currentParams).notifier)
              .saveSubject(newSubject)
              .withToast(context);
        },
      ),
    );
  }

  void _showUpdateDialog(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    SubjectSearchParams currentParams,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => UpdateSubjectDialog(
        subject: subject,
        onUpdate: (newName, newCode) {
          final updated = subject.copyWith(name: newName, code: newCode);
          ref
              .read(subjectProvider(currentParams).notifier)
              .saveSubject(updated)
              .withToast(context);
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    SubjectSearchParams currentParams,
  ) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        itemName: subject.name,
        onDelete: () {
          ref
              .read(subjectProvider(currentParams).notifier)
              .deleteSubject(subject.id)
              .withToast(context);
        },
      ),
    );
  }
}
