import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/services/quiz_convert_service.dart';
import 'package:frontend/features/library/widgets/question/question_item.dart';

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
      (q) => q.explanation.contains(QuizConverterService.errorFlag),
    );

    if (showOnlyErrors && errorQuestions.isEmpty) {
      Future.microtask(onAutoDisableError);
    }

    final baseFiltered = showOnlyErrors ? errorQuestions : allQuestions;
    final filtered = baseFiltered.where((q) {
      final kw = params.keyword?.toLowerCase() ?? '';
      return q.content.toLowerCase().contains(kw) ||
          q.answers.any((a) => a.content.toLowerCase().contains(kw));
    }).toList();

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
              mainAxisExtent: 520,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: pagedList.length,
            itemBuilder: (context, index) {
              final question = pagedList[index];
              return QuestionItem(
                key: ObjectKey(question),
                index: (params.page * params.size) + index + 1,
                question: question,
                isNew: question.content.isEmpty,
                onSave: (updated) =>
                    onUpdate(allQuestions.indexOf(question), updated),
                onDelete: () => onDelete(allQuestions.indexOf(question)),
              );
            },
          ),
        ),
        AppPagination(
          currentPage: params.page,
          totalPages: totalPages,
          activeColor: LibraryColors.accentColor,
          onPageChange: onPageChange,
        ),
      ],
    );
  }
}
