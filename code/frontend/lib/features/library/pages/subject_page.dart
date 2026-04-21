import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/pagination.dart'; // Import Widget phân trang của bạn
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/search_params/subject_search_params.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/widgets/subject/subject_header.dart';
import 'package:frontend/features/library/widgets/subject/subject_item.dart';
import 'package:frontend/features/library/widgets/subject/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectPage extends HookConsumerWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Khởi tạo Params (Mặc định trang 0, mỗi trang 12 môn)
    final searchParamsNotifier = useState(
      SubjectSearchParams(size: 12, page: 0),
    );

    // 2. Watch data theo searchParamsNotifier hiện tại
    final subjectsAsync = ref.watch(
      watchSubjectsProvider(searchParamsNotifier.value),
    );
    final totalPagesAsync = ref.watch(
      watchSubjectTotalPagesProvider(searchParamsNotifier.value),
    );

    return Material(
      color: LibraryColors.background,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trong SubjectPage.dart
            SubjectHeader(
              params: searchParamsNotifier.value,
              onAddSuccess: () async {
                // Chờ một chút để dữ liệu được cập nhật hoặc dùng Future để lấy giá trị mới
                final totalPages = await ref.read(
                  watchSubjectTotalPagesProvider(
                    searchParamsNotifier.value,
                  ).future,
                );

                // Nhảy tới trang cuối cùng (totalPages - 1 vì index bắt đầu từ 0)
                if (totalPages > 0) {
                  searchParamsNotifier.value = searchParamsNotifier.value
                      .copyWith(page: totalPages - 1);
                }
              },
            ),
            const SizedBox(height: 40),

            // Search Bar: Khi gõ sẽ cập nhật keyword và reset về trang đầu tiên
            AppSearchBar(
              onSearch: (v) => searchParamsNotifier.value = searchParamsNotifier
                  .value
                  .copyWith(keyword: v, page: 0),
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
                              searchParamsNotifier.value,
                            ),
                            onDelete: () => _confirmDelete(
                              context,
                              ref,
                              list[index],
                              searchParamsNotifier,
                            ),
                          ),
                        ),
                      ),

                      // THANH PHÂN TRANG (PAGINATION)
                      const SizedBox(height: 24),
                      totalPagesAsync.maybeWhen(
                        data: (total) => AppPagination(
                          currentPage: searchParamsNotifier.value.page,
                          totalPages: total,
                          activeColor: LibraryColors.accentColor,
                          onPageChange: (newPage) {
                            searchParamsNotifier.value = searchParamsNotifier
                                .value
                                .copyWith(page: newPage);
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
          subject
            ..name = newName
            ..code = newCode;
          ref
              .read(subjectProvider.notifier)
              .saveSubject(subject)
              .withToast(context);
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    ValueNotifier<SubjectSearchParams> searchParamsNotifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        itemName: subject.name,
        onDelete: () async {
          final currentParams = searchParamsNotifier.value;
          // 1. Thực hiện xóa và đợi kết quả
          await ref
              .read(subjectProvider.notifier)
              .deleteSubject(subject.id)
              .withToast(context);

          // 2. Lấy tổng số trang sau khi xóa
          final newTotalPages = await ref.read(
            watchSubjectTotalPagesProvider(currentParams).future,
          );

          // 3. Kiểm tra logic lùi trang
          // Nếu trang hiện tại >= tổng số trang mới (nghĩa là trang đó đã bị rỗng)
          // và trang hiện tại > 0 thì lùi về trang trước.
          if (currentParams.page >= newTotalPages && currentParams.page > 0) {
            // params ở đây chính là biến 'params' trong Widget build
            // dùng 'ref' hoặc truyền tham chiếu để cập nhật
            // Với cách bạn dùng useState, hãy cập nhật như sau:
            final newPage = newTotalPages > 0 ? newTotalPages - 1 : 0;

            // Cập nhật lại params của state
            // Lưu ý: Nếu hàm này nằm trong SubjectPage, bạn có thể gọi trực tiếp:
            searchParamsNotifier.value = searchParamsNotifier.value.copyWith(
              page: newPage,
            );
            // (Để làm được điều này, hãy truyền 'params' vào _confirmDelete)
          }
        },
      ),
    );
  }
}
