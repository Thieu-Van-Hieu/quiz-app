import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/widgets/input/search_bar.dart';
import 'package:frontend/core/widgets/text/highlighted_text.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/utilities/services/quiz_merger.dart';
import 'package:frontend/features/utilities/widgets/tool_common.dart';

/// Tab "Gộp quiz" (port từ index.html - QuizApp Merge Quiz)
class MergeTab extends HookWidget {
  final SearchCorpus corpus;

  const MergeTab({super.key, required this.corpus});

  @override
  Widget build(BuildContext context) {
    // Giữ thứ tự chọn: bộ đề chọn trước được ưu tiên khi gặp câu trùng
    final selectedIds = useState<List<int>>([]);
    final keyword = useState('');
    final criteria = useState(MergeDuplicateCriteria.contentAndAnswers);
    final action = useState(MergeDuplicateAction.skip);

    final matcher = TextMatcher(keyword.value);
    final quizzes = matcher.filter(
      [...corpus.quizzes]..sort((a, b) => quizLabel(a).compareTo(quizLabel(b))),
      (q) => [quizLabel(q)],
    );
    final selectedQuizzes = [
      for (final id in selectedIds.value)
        ?corpus.quizzes.where((q) => q.id == id).firstOrNull,
    ];

    final result = QuizMerger.merge(
      [for (final q in selectedQuizzes) questionsOfQuiz(corpus, q.id)],
      criteria: criteria.value,
      action: action.value,
    );

    void toggle(int id, bool selected) {
      selectedIds.value = selected
          ? [...selectedIds.value, id]
          : selectedIds.value.where((e) => e != id).toList();
    }

    return ListView(
      children: [
        ToolSection(
          title: "Chọn các bộ đề cần gộp (${selectedQuizzes.length})",
          subtitle: "Thứ tự chọn là thứ tự gộp",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchBar(
                hintText: "Lọc bộ đề...",
                onSearch: (v) => keyword.value = v,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final quiz in quizzes)
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedIds.value.contains(quiz.id),
                        onChanged: (v) => toggle(quiz.id, v ?? false),
                        title: HighlightedText(
                          quizLabel(quiz),
                          matcher: matcher,
                        ),
                        secondary: selectedIds.value.contains(quiz.id)
                            ? CircleAvatar(
                                radius: 12,
                                child: Text(
                                  '${selectedIds.value.indexOf(quiz.id) + 1}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ToolSection(
          title: "Xử lý câu trùng",
          child: Row(
            children: [
              Expanded(
                child: OptionDropdown<MergeDuplicateCriteria>(
                  value: criteria.value,
                  values: MergeDuplicateCriteria.values,
                  labelOf: (c) => c.label,
                  onChanged: (v) => criteria.value = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OptionDropdown<MergeDuplicateAction>(
                  value: action.value,
                  values: MergeDuplicateAction.values,
                  labelOf: (a) => a.label,
                  onChanged: (v) => action.value = v,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ToolSection(
          title: "Kết quả: ${result.questions.length} câu",
          subtitle:
              "Tổng ${result.inputCount} câu đầu vào, "
              "phát hiện ${result.duplicateCount} câu trùng",
          child: QuestionPreviewList(questions: result.questions),
        ),
        const SizedBox(height: 16),
        SaveAsQuizPanel(
          corpus: corpus,
          questions: selectedQuizzes.length < 2 ? const [] : result.questions,
          defaultName: selectedQuizzes.map((q) => q.name).join(' + '),
          defaultSubjectId: selectedQuizzes.firstOrNull?.subject.target?.id,
        ),
      ],
    );
  }
}
