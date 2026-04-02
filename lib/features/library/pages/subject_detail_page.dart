import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/widgets/delete_confirm_dialog.dart'; // Import hàng xịn đã tách
import 'package:frontend/features/library/widgets/quiz/quiz_item.dart';
import 'package:frontend/features/library/widgets/quiz/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubjectDetailPage extends HookConsumerWidget {
  final int subjectId;
  const SubjectDetailPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Khai báo state để giữ từ khóa tìm kiếm
    final searchQuery = useState('');
    final quizzesAsync = ref.watch(quizNotifierProvider(subjectId));

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER SECTION ---
          _buildHeader(context, ref),
          const SizedBox(height: 40),

          // --- SEARCH SECTION (Mới thêm) ---
          // Khống chế width khoảng 600 để trên Desktop nhìn cho sang
          AppSearchBar(onSearch: (v) => searchQuery.value = v),
          const SizedBox(height: 32),

          // --- CONTENT SECTION ---
          Expanded(
            child: quizzesAsync.when(
              data: (quizzes) {
                // 2. Logic Filter bộ đề theo tên
                final filteredQuizzes = quizzes
                    .where(
                      (q) => q.name.toLowerCase().contains(
                        searchQuery.value.toLowerCase(),
                      ),
                    )
                    .toList();

                if (filteredQuizzes.isEmpty) {
                  return const Center(
                    child: Text(
                      AppStrings.noData,
                      style: TextStyle(color: LibraryColors.secondaryText),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: filteredQuizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = filteredQuizzes[index];
                    return QuizItem(
                      quiz: quiz,
                      onTap: () => _onQuizTap(context, quiz),
                      onEdit: () => _showUpdateQuizDialog(context, ref, quiz),
                      onDelete: () => _confirmDelete(context, ref, quiz),
                    );
                  },
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

  // --- UI HELPERS ---

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
            enabledMouseCursor: SystemMouseCursors.click,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  // --- ACTIONS ---

  void _showAddQuizDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _AddQuizDialog(
        onSave: (name) {
          final newQuiz = Quiz()..name = name;
          ref
              .read(quizNotifierProvider(subjectId).notifier)
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
          quiz.name = newName;
          ref
              .read(quizNotifierProvider(subjectId).notifier)
              .saveQuiz(subjectId, quiz)
              .withToast(context);
        },
      ),
    );
  }

  // SỬ DỤNG WIDGET DÙNG CHUNG ĐÃ TÁCH
  void _confirmDelete(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmDialog(
        itemName: quiz.name,
        onDelete: () {
          ref
              .read(quizNotifierProvider(subjectId).notifier)
              .deleteQuiz(quiz.id)
              .withToast(context);
        },
      ),
    );
  }

  void _onQuizTap(BuildContext context, dynamic quiz) {
    context.go(LibraryRoutes.getQuizDetailPath(subjectId, quiz.id));
  }
}

// --- WIDGET DIALOG THÊM MỚI (Nên tách ra file riêng nếu cần tái sử dụng) ---

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
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(AppStrings.btnCancel),
        ),
        const SizedBox(width: 8),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
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
