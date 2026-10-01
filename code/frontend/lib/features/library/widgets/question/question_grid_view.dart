import 'package:flutter/material.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/widgets/layout/pagination.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/services/quiz/quiz_text_parser.dart';
import 'package:frontend/features/library/widgets/question/question_card.dart';

class QuestionGridView extends StatelessWidget {
  final List<Question> allQuestions;
  final QuestionSearchParams params;
  final bool showOnlyErrors;
  final Function(int) onPageChange;
  final Function(int, Question) onUpdate;
  final Function(int) onDelete;
  final VoidCallback onAutoDisableError;

  const QuestionGridView({
    super.key,
    required this.allQuestions,
    required this.params,
    required this.showOnlyErrors,
    required this.onPageChange,
    required this.onUpdate,
    required this.onDelete,
    required this.onAutoDisableError,
  });

  @override
  Widget build(BuildContext context) {
    final errorQuestions = allQuestions.where(
      (q) => q.explanation.contains(QuizTextParser.errorFlag),
    );

    if (showOnlyErrors && errorQuestions.isEmpty) {
      Future.microtask(onAutoDisableError);
    }

    final baseFiltered = showOnlyErrors ? errorQuestions : allQuestions;
    final matcher = TextMatcher(params.keyword ?? '', params.options);
    final filtered = matcher.filter(
      baseFiltered,
      (q) => [q.content, q.explanation, ...q.answers.map((a) => a.content)],
    );

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          allQuestions.isEmpty
              ? "Quiz chưa có câu hỏi"
              : "Không tìm thấy kết quả",
        ),
      );
    }

    final totalItems = filtered.length;
    final totalPages = (totalItems / params.size).ceil();
    final start = params.page * params.size;
    final end = (start + params.size) > totalItems
        ? totalItems
        : (start + params.size);
    final pagedList = filtered.sublist(start, end);

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 600,
              mainAxisExtent: 540,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: pagedList.length,
            itemBuilder: (context, index) {
              final question = pagedList[index];
              return QuestionCard(
                key: ObjectKey(question),
                index: (params.page * params.size) + index + 1,
                question: question,
                isNew: question.content.isEmpty,
                matcher: matcher.isEmpty ? null : matcher,
                onSave: (updated) =>
                    onUpdate(allQuestions.indexOf(question), updated),
                onDelete: () => onDelete(allQuestions.indexOf(question)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: AppPagination(
            currentPage: params.page,
            totalPages: totalPages,
            onPageChange: onPageChange,
          ),
        ),
      ],
    );
  }
}
