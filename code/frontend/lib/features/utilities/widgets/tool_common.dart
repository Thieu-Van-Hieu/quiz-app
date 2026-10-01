import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/utilities/notifiers/quiz_tools_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Câu hỏi của 1 quiz trong corpus, theo đúng thứ tự trong quiz (theo id)
List<Question> questionsOfQuiz(SearchCorpus corpus, int quizId) =>
    corpus.questions.where((q) => q.quiz.target?.id == quizId).toList()
      ..sort((a, b) => a.id.compareTo(b.id));

/// Nhãn "MÃ MÔN · Tên quiz" để hiển thị
String quizLabel(Quiz quiz) {
  final code = quiz.subject.target?.code;
  return code == null ? quiz.name : '$code · ${quiz.name}';
}

/// Khung bọc 1 khối nội dung trong trang Công cụ
class ToolSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const ToolSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LibraryColors.divider, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: LibraryColors.primaryText,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: LibraryColors.secondaryText,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Dropdown chọn 1 bộ đề (gom theo môn học)
class QuizDropdown extends StatelessWidget {
  final SearchCorpus corpus;
  final int? value;
  final ValueChanged<int?> onChanged;
  final String hint;

  const QuizDropdown({
    super.key,
    required this.corpus,
    required this.value,
    required this.onChanged,
    this.hint = "Chọn bộ đề",
  });

  @override
  Widget build(BuildContext context) {
    final quizzes = [...corpus.quizzes]
      ..sort((a, b) => quizLabel(a).compareTo(quizLabel(b)));
    final counts = <int, int>{};
    for (final q in corpus.questions) {
      final id = q.quiz.target?.id;
      if (id != null) counts.update(id, (v) => v + 1, ifAbsent: () => 1);
    }

    return _OutlinedBox(
      child: DropdownButton<int>(
        value: quizzes.any((q) => q.id == value) ? value : null,
        hint: Text(hint),
        isExpanded: true,
        borderRadius: BorderRadius.circular(12),
        items: [
          for (final quiz in quizzes)
            DropdownMenuItem(
              value: quiz.id,
              child: Text(
                '${quizLabel(quiz)}  (${counts[quiz.id] ?? 0} câu)',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _OutlinedBox extends StatelessWidget {
  final Widget child;

  const _OutlinedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }
}

/// Dropdown chọn 1 giá trị enum / tuỳ chọn bất kỳ
class OptionDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const OptionDropdown({
    super.key,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _OutlinedBox(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        borderRadius: BorderRadius.circular(12),
        items: [
          for (final v in values)
            DropdownMenuItem(value: v, child: Text(labelOf(v))),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

/// Xem trước danh sách câu hỏi (rút gọn)
class QuestionPreviewList extends StatelessWidget {
  final List<Question> questions;
  final int limit;

  const QuestionPreviewList({
    super.key,
    required this.questions,
    this.limit = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Text(
        "Không có câu hỏi nào.",
        style: TextStyle(color: LibraryColors.secondaryText),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final q in questions.take(limit))
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '• ${q.content}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, height: 1.4),
            ),
          ),
        if (questions.length > limit)
          Text(
            '... và ${questions.length - limit} câu khác',
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: LibraryColors.secondaryText,
            ),
          ),
      ],
    );
  }
}

/// Khung "Lưu thành bộ đề mới": chọn môn + đặt tên + nút tạo
class SaveAsQuizPanel extends HookConsumerWidget {
  final SearchCorpus corpus;
  final List<Question> questions;
  final String defaultName;
  final int? defaultSubjectId;

  const SaveAsQuizPanel({
    super.key,
    required this.corpus,
    required this.questions,
    required this.defaultName,
    this.defaultSubjectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: defaultName);
    // Cập nhật tên gợi ý khi nguồn câu hỏi thay đổi
    useEffect(() {
      nameController.text = defaultName;
      return null;
    }, [defaultName]);

    final subjectId = useState<int?>(defaultSubjectId);
    useEffect(() {
      subjectId.value ??= defaultSubjectId;
      return null;
    }, [defaultSubjectId]);

    final isSaving = useState(false);
    final subjects = [...corpus.subjects]
      ..sort((a, b) => a.code.compareTo(b.code));

    Future<void> save() async {
      final targetSubject = subjectId.value;
      if (targetSubject == null) return;
      isSaving.value = true;
      final quiz = await ref
          .read(quizToolsProvider.notifier)
          .createQuiz(
            subjectId: targetSubject,
            name: nameController.text,
            questions: questions,
          )
          .withToast(context);
      isSaving.value = false;

      if (quiz != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã tạo bộ đề "${quiz.name}" với ${questions.length} câu.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    return ToolSection(
      title: "Lưu thành bộ đề mới",
      subtitle: "Câu hỏi được sao chép, bộ đề gốc không bị thay đổi",
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: _OutlinedBox(
              child: DropdownButton<int>(
                value: subjectId.value,
                hint: const Text("Chọn môn học"),
                isExpanded: true,
                borderRadius: BorderRadius.circular(12),
                items: [
                  for (final s in subjects)
                    DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        '${s.code} - ${s.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => subjectId.value = v,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Tên bộ đề mới",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            label: "Tạo bộ đề (${questions.length} câu)",
            icon: Icons.library_add_rounded,
            variant: ButtonVariant.brand,
            size: ButtonSize.medium,
            isLoading: isSaving.value,
            onPressed:
                questions.isEmpty || subjectId.value == null || isSaving.value
                ? null
                : save,
          ),
        ],
      ),
    );
  }
}
