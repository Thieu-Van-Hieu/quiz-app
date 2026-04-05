import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/notifiers/question_notifier.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/widgets/question/question_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend/features/library/models/answer.dart';

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
    final params = useState(
      QuestionSearchParams(quizId: quizId, size: 10, page: 0),
    );

    final quizAsync = ref.watch(watchQuizProvider(quizId));
    final questionsAsync = ref.watch(questionProvider(quizId));
    final questionActions = ref.read(questionProvider(quizId).notifier);

    final quizName = quizAsync.maybeWhen(
      data: (quiz) => quiz?.name ?? "Không xác định",
      loading: () => AppStrings.loading,
      orElse: () => AppStrings.error,
    );

    // Thay vì Scaffold, dùng Padding trực tiếp
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, quizName, questionsAsync, questionActions),
          const SizedBox(height: 32),

          AppSearchBar(
            hintText: LibraryStrings.searchQuestionHint,
            onSearch: (v) =>
                params.value = params.value.copyWith(keyword: v, page: 0),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: questionsAsync.when(
              data: (allQuestions) {
                // Logic filter trên RAM
                final filtered = allQuestions.where((q) {
                  final kw = params.value.keyword?.toLowerCase() ?? '';
                  if (kw.isEmpty) return true;
                  final matchQuestion = q.content.toLowerCase().contains(kw);
                  final matchAnswers = q.answers.any(
                    (a) => a.content.toLowerCase().contains(kw),
                  );
                  return matchQuestion || matchAnswers;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(LibraryStrings.emptyQuestions),
                  );
                }

                // Logic phân trang trên RAM
                final totalItems = filtered.length;
                final totalPages = (totalItems / params.value.size).ceil();
                final start = params.value.page * params.value.size;
                final end = (start + params.value.size) > totalItems
                    ? totalItems
                    : (start + params.value.size);
                final pagedList = filtered.sublist(start, end);

                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 600,
                              mainAxisExtent: 450,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                        itemCount: pagedList.length,
                        itemBuilder: (context, index) {
                          final question = pagedList[index];
                          final originalIndex = allQuestions.indexOf(question);

                          return MouseRegion(
                            cursor: SystemMouseCursors
                                .click, // Đảm bảo hiện bàn tay khi rê vào card
                            child: QuestionItem(
                              key: ValueKey(
                                "q_${question.id}_${question.answers.length}",
                              ),
                              index: originalIndex + 1,
                              question: question,
                              isNew: question.content.isEmpty,
                              onSave: (updated) => questionActions
                                  .updateQuestion(originalIndex, updated),
                              onDelete: () =>
                                  questionActions.deleteQuestion(originalIndex),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pagination
                    AppPagination(
                      currentPage: params.value.page,
                      totalPages: totalPages,
                      activeColor: LibraryColors.accentColor,
                      onPageChange: (newPage) {
                        params.value = params.value.copyWith(page: newPage);
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("${AppStrings.error}: $e")),
            ),
          ),
        ],
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
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          mouseCursor: SystemMouseCursors.click, // Ép hiện con trỏ
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

        // Các nút chức năng có ép con trỏ click
        _HeaderButton(
          onPressed: () async => await notifier.refresh(),
          icon: Icons.sync_problem_rounded,
          label: "Khôi phục",
          color: LibraryColors.secondaryText,
        ),
        const SizedBox(width: 16),
        _HeaderButton(
          onPressed: () async => await notifier.saveToDb(),
          icon: Icons.cloud_upload_outlined,
          label: LibraryStrings.btnSyncDb,
          color: AppColors.success,
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            final newQuestion = Question(content: "", explanation: "");
            newQuestion.answers.addAll([
              Answer(content: "", isCorrect: true),
              Answer(content: "", isCorrect: false),
            ]);
            notifier.addQuestion(newQuestion);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text(LibraryStrings.btnAddQuestion),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledMouseCursor: SystemMouseCursors.click,
            disabledMouseCursor: SystemMouseCursors.forbidden,
          ),
        ),
      ],
    );
  }
}

// Widget phụ để tái sử dụng style cho các nút TextButton trong Header
class _HeaderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _HeaderButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      // Đưa mouseCursor vào trong ButtonStyle thay vì để ở ngoài
      style: ButtonStyle(
        mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        // Nếu bản Flutter của bạn quá cũ, hãy thay WidgetStateProperty bằng MaterialStateProperty
      ),
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
