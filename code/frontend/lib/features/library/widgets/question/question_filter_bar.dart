import 'package:flutter/material.dart';
import 'package:frontend/core/search/search_options.dart';
import 'package:frontend/core/widgets/input/search_bar.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/services/quiz/quiz_text_parser.dart';

class QuestionFilterBar extends StatelessWidget {
  final List<Question> questions;
  final Function(String) onSearch;
  final String initialKeyword;
  final SearchOptions options;
  final ValueChanged<SearchOptions> onOptionsChanged;
  final String? searchError;
  final bool showOnlyErrors;
  final Function(bool) onToggleError;

  const QuestionFilterBar({
    super.key,
    required this.questions,
    required this.onSearch,
    this.initialKeyword = '',
    required this.options,
    required this.onOptionsChanged,
    this.searchError,
    required this.showOnlyErrors,
    required this.onToggleError,
  });

  @override
  Widget build(BuildContext context) {
    final errorCount = questions
        .where((q) => q.explanation.contains(QuizTextParser.errorFlag))
        .length;

    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: LibraryStrings.searchQuestionHint,
            onSearch: onSearch,
            initialValue: initialKeyword,
            options: options,
            onOptionsChanged: onOptionsChanged,
            error: searchError,
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
            mouseCursor: SystemMouseCursors.click,
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
