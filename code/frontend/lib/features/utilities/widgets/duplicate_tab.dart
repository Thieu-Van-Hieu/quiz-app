import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/question_page_args.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/utilities/notifiers/quiz_tools_notifier.dart';
import 'package:frontend/features/utilities/widgets/tool_common.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Tab "Lọc trùng" (port từ filter.py)
class DuplicateTab extends HookConsumerWidget {
  final SearchCorpus corpus;

  const DuplicateTab({super.key, required this.corpus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizId = useState<int?>(null);
    final quiz = corpus.quizzes.where((q) => q.id == quizId.value).firstOrNull;
    final report = useMemoized(
      () => quiz == null
          ? null
          : QuizDeduplicator.findDuplicateGroups(
              questionsOfQuiz(corpus, quiz.id),
            ),
      [corpus, quizId.value],
    );

    Future<void> removeFullDuplicates() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AppAlertDialog(
          title: "Xoá câu trùng hoàn toàn",
          content: Text(
            "Xoá ${report!.removableCount} câu trùng cả câu hỏi lẫn đáp án, "
            "mỗi nhóm giữ lại câu đầu tiên. Thao tác này lưu thẳng vào bộ đề.",
          ),
          actions: [
            AppButton(
              label: "Xoá",
              variant: ButtonVariant.danger,
              size: ButtonSize.small,
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;

      final removed = await ref
          .read(quizToolsProvider.notifier)
          .removeFullDuplicates(quiz!.id)
          .withToast(context);
      if (removed != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Đã xoá $removed câu trùng."),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    void openInQuiz(Question question) {
      context.go(
        LibraryRoutes.getQuizDetailPath(quiz!.subject.targetId, quiz.id),
        extra: QuestionPageArgs(keyword: question.content.trim()),
      );
    }

    return ListView(
      children: [
        QuizDropdown(
          corpus: corpus,
          value: quizId.value,
          onChanged: (v) => quizId.value = v,
        ),
        const SizedBox(height: 16),
        if (report == null)
          const Center(child: Text("Chọn 1 bộ đề để kiểm tra trùng lặp"))
        else if (report.isEmpty)
          const Center(child: Text("✅ Không phát hiện câu trùng"))
        else ...[
          ToolSection(
            title:
                "Trùng cả câu hỏi và đáp án "
                "(${report.fullGroups.length} nhóm, có thể xoá ${report.removableCount} câu)",
            subtitle: "An toàn để xoá, mỗi nhóm giữ lại 1 câu",
            trailing: report.fullGroups.isEmpty
                ? null
                : AppButton(
                    label: "Xoá ${report.removableCount} câu trùng",
                    icon: Icons.delete_sweep_rounded,
                    variant: ButtonVariant.danger,
                    size: ButtonSize.small,
                    onPressed: removeFullDuplicates,
                  ),
            child: _GroupList(groups: report.fullGroups),
          ),
          const SizedBox(height: 16),
          ToolSection(
            title:
                "Chỉ trùng câu hỏi, khác đáp án (${report.contentOnlyGroups.length} nhóm)",
            subtitle:
                "Có thể nhập sai đáp án. Mở bộ đề để kiểm tra và sửa thủ công.",
            child: _GroupList(
              groups: report.contentOnlyGroups,
              showAnswers: true,
              onOpen: openInQuiz,
            ),
          ),
        ],
      ],
    );
  }
}

class _GroupList extends StatelessWidget {
  final List<List<Question>> groups;
  final bool showAnswers;
  final void Function(Question)? onOpen;

  const _GroupList({
    required this.groups,
    this.showAnswers = false,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const Text("Không có");

    String answersOf(Question q) =>
        (q.answers.toList()
              ..sort((a, b) => a.indexOrder.compareTo(b.indexOrder)))
            .map((a) => a.isCorrect ? '✔ ${a.content}' : a.content)
            .join('  |  ');

    return Column(
      children: [
        for (final group in groups)
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              '${group.first.content}  (${group.length} câu)',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: onOpen == null
                ? null
                : TextButton(
                    onPressed: () => onOpen!(group.first),
                    child: const Text("Mở trong bộ đề"),
                  ),
            children: [
              if (showAnswers)
                for (final (i, q) in group.indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bản ${i + 1}: ${answersOf(q)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: LibraryColors.primaryText,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
      ],
    );
  }
}
