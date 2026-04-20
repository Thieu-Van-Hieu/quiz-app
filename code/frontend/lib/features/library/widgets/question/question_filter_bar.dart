import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/services/quiz_convert_service.dart';

class QuestionFilterBar extends StatelessWidget {
  final List<Question> questions;
  final Function(String) onSearch;
  final bool showOnlyErrors;
  final Function(bool) onToggleError;

  const QuestionFilterBar({
    super.key,
    required this.questions,
    required this.onSearch,
    required this.showOnlyErrors,
    required this.onToggleError,
  });

  @override
  Widget build(BuildContext context) {
    final errorCount = questions
        .where((q) => q.explanation.contains(QuizConverterService.errorFlag))
        .length;

    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: LibraryStrings.searchQuestionHint,
            onSearch: onSearch,
          ),
        ),
        if (errorCount > 0) ...[
          const SizedBox(width: 16),
          FilterChip(
            label: Text("Câu lỗi ($errorCount)"),
            selected: showOnlyErrors,
            onSelected: onToggleError,
            backgroundColor: Colors.red.shade50,
            selectedColor: Colors.red.shade100,
            checkmarkColor: Colors.red,
            labelStyle: TextStyle(
              color: showOnlyErrors ? Colors.red : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
