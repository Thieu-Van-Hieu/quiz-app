import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/quiz_search_params.dart'; // Đảm bảo đã tạo file này
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/widgets/delete_confirm_dialog.dart';
import 'package:frontend/features/library/widgets/quiz/quiz_item.dart';
import 'package:frontend/features/library/widgets/quiz/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectDetailPage extends HookConsumerWidget {
  final int subjectId;
  const SubjectDetailPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Quản lý toàn bộ trạng thái Search & Page qua 1 Object duy nhất
    final params = useState(
      QuizSearchParams(
        subjectId: subjectId,
        size: 10, // Số bộ đề mỗi trang
        page: 0,
      ),
    );

    // 2. Watch data từ Notifier (đã truyền params vào build)
    final quizzesAsync = ref.watch(quizProvider(params.value));

    // 3. Watch tổng số trang (để hiển thị AppPagination)
    // Giả sử bạn đã tạo provider này trong quiz_notifier như hướng dẫn trước
    final totalPagesAsync = ref.watch(quizTotalPagesProvider(params.value));

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, ref),
          const SizedBox(height: 40),

          // --- SEARCH SECTION ---
          AppSearchBar(
            onSearch: (v) {
              // Khi search, phải reset page về 0
              params.value = params.value.copyWith(keyword: v, page: 0);
            },
          ),
          const SizedBox(height: 32),

          // --- CONTENT SECTION ---
          Expanded(
            child: quizzesAsync.when(
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return const Center(
                    child: Text(
                      AppStrings.noData,
                      style: TextStyle(color: LibraryColors.secondaryText),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Danh sách bộ đề
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: quizzes.length,
                        // Cấu hình Grid
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisExtent: 180,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                        itemBuilder: (context, index) {
                          final quiz = quizzes[index];
                          return QuizItem(
                            quiz: quiz,
                            onTap: () => _onQuizTap(context, quiz),
                            onEdit: () =>
                                _showUpdateQuizDialog(context, ref, quiz),
                            onDelete: () => _confirmDelete(context, ref, quiz),
                          );
                        },
                      ),
                    ),

                    // --- PAGINATION WIDGET ---
                    const SizedBox(height: 16),
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
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: LibraryColors.accentColor,
                ),
              ),
              error: (e, _) => Center(child: Text("Lỗi hệ thống: $e")),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS & ACTIONS (Giữ nguyên logic của bạn) ---

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LibraryStrings.detailTitle,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: LibraryColors.primaryText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              LibraryStrings.detailSubtitle,
              style: TextStyle(
                color: LibraryColors.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddQuizDialog(context, ref),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            LibraryStrings.btnAddQuiz,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }

  void _showAddQuizDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _AddQuizDialog(
        onSave: (name) {
          final newQuiz = Quiz(name: name);
          ref
              .read(
                quizProvider(QuizSearchParams(subjectId: 0)).notifier,
              ) // Dùng notifier bất kỳ để gọi save
              .saveQuiz(subjectId, newQuiz)
              .withToast(context);
        },
      ),
    );
  }

  void _showUpdateQuizDialog(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => UpdateQuizDialog(
        quiz: quiz,
        onUpdate: (newName) {
          final updatedQuiz = quiz.copyWith(name: newName);
          ref
              .read(quizProvider(QuizSearchParams(subjectId: 0)).notifier)
              .saveQuiz(subjectId, updatedQuiz)
              .withToast(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmDialog(
        itemName: quiz.name,
        onDelete: () {
          ref
              .read(quizProvider(QuizSearchParams(subjectId: 0)).notifier)
              .deleteQuiz(quiz.id)
              .withToast(context);
        },
      ),
    );
  }

  void _onQuizTap(BuildContext context, Quiz quiz) {
    context.go(LibraryRoutes.getQuizDetailPath(subjectId, quiz.id));
  }
}

// --- GIỮ NGUYÊN _AddQuizDialog CỦA BẠN ---
class _AddQuizDialog extends HookWidget {
  final Function(String) onSave;
  const _AddQuizDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogAddQuizTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            LibraryStrings.dialogLabelQuizName,
            style: TextStyle(fontSize: 14, color: LibraryColors.secondaryText),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: LibraryStrings.hintQuizName,
              filled: true,
              fillColor: AppColors.searchBarBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            // Cấu hình con trỏ chuột trong style
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors
                .forbidden, // Hiện biển cấm khi nút bị disable
          ),
          child: const Text(AppStrings.btnCancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onSave(controller.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors.forbidden,
          ),
          child: const Text(
            AppStrings.btnSave,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
