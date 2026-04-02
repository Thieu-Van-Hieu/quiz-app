import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart'; // Import Strings
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/notifiers/question_notifier.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/widgets/question_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizDetailPage extends HookConsumerWidget {
  final int subjectId;
  final int quizId;

  const QuizDetailPage({
    super.key,
    required this.subjectId,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');

    // 1. Lấy thông tin Tên Quiz
    final quizName = ref.watch(
      quizNotifierProvider(subjectId).select(
        (stream) => stream.when(
          data: (list) => list.firstWhere((q) => q.id == quizId).name,
          loading: () => AppStrings.loading,
          error: (_, __) => AppStrings.error,
        ),
      ),
    );

    // 2. Lấy danh sách câu hỏi và các action CRUD
    final questionsAsync = ref.watch(questionNotifierProvider(quizId));
    final questionActions = ref.read(questionNotifierProvider(quizId).notifier);

    return Scaffold(
      backgroundColor: LibraryColors.background,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            _buildHeader(context, quizName, questionsAsync, questionActions),
            const SizedBox(height: 32),

            // --- SEARCH BAR ---
            AppSearchBar(
              hintText: LibraryStrings.searchQuestionHint,
              onSearch: (v) => searchQuery.value = v,
            ),
            const SizedBox(height: 32),

            // --- QUESTIONS GRID ---
            Expanded(
              child: questionsAsync.when(
                data: (questions) {
                  final filtered = questions
                      .where(
                        (q) => q.content.toLowerCase().contains(
                          searchQuery.value.toLowerCase(),
                        ),
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(LibraryStrings.emptyQuestions),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 600,
                          mainAxisExtent: 450,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final question = filtered[index];
                      return QuestionItem(
                        key: ValueKey(
                          "${question.content}_${index}_${question.options.length}",
                        ),
                        index: index + 1,
                        question: question,
                        isNew: question.content.isEmpty,
                        onSave: (updatedQuestion) {
                          questionActions.updateQuestion(
                            index,
                            updatedQuestion,
                          );
                        },
                        onDelete: () => questionActions.deleteQuestion(index),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("${AppStrings.error}: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String quizName,
    AsyncValue<List<Question>> questionsAsync,
    QuestionNotifier notifier,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: LibraryColors.primaryText,
              ),
            ),
            questionsAsync.maybeWhen(
              data: (list) => Text(
                "${list.length} ${LibraryStrings.labelQuestionCount}",
                style: const TextStyle(color: LibraryColors.secondaryText),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const Spacer(),

        // NÚT LƯU DATABASE (SYNC)
        TextButton.icon(
          onPressed: () async {
            await notifier.saveToDb();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(LibraryStrings.snackbarSyncSuccess),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          icon: const Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.success,
          ),
          label: const Text(
            LibraryStrings.btnSyncDb,
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
        ),
        const SizedBox(width: 16),

        // NÚT THÊM CÂU HỎI MỚI
        ElevatedButton.icon(
          onPressed: () {
            final newQuestion = Question()
              ..content =
                  "" // Để rỗng hoàn toàn để isNew nhận diện đúng
              ..options =
                  ["", ""] // Khởi tạo 2 đáp án trống
              ..correctOptions = [0];

            notifier.addQuestion(newQuestion);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text(LibraryStrings.btnAddQuestion),
          style: ElevatedButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
