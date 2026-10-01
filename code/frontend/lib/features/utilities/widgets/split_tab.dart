import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/utilities/services/quiz_analyzer.dart';
import 'package:frontend/features/utilities/services/quiz_splitter.dart';
import 'package:frontend/features/utilities/widgets/tool_common.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SplitSource {
  range("Theo khoảng câu"),
  session("Từ 1 phiên học"),
  sharedCorrect("Nhóm: đáp án đúng giống nhau"),
  confusable("Nhóm: đáp án đúng bị dùng làm đáp án sai"),
  phrases("Nhóm: có cụm từ chỉ xuất hiện trong đáp án đúng");

  final String label;

  const SplitSource(this.label);
}

/// Tab "Tách quiz" (port từ split.py + tách theo khoảng câu / theo session)
class SplitTab extends HookConsumerWidget {
  final SearchCorpus corpus;

  const SplitTab({super.key, required this.corpus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizId = useState<int?>(null);
    final source = useState(SplitSource.range);
    final fromController = useTextEditingController(text: '1');
    final toController = useTextEditingController(text: '50');
    useListenable(fromController);
    useListenable(toController);
    final sessionId = useState<int?>(null);
    final sessionFilter = useState(SessionQuestionFilter.wrong);

    final quiz = corpus.quizzes.where((q) => q.id == quizId.value).firstOrNull;
    final questions = quiz == null
        ? const <Question>[]
        : questionsOfQuiz(corpus, quiz.id);

    // Danh sách session của quiz đang chọn (memo params để provider không bị tạo lại mỗi lần build)
    final sessionParams = useMemoized(
      () => LearningSessionSearchParams(quizId: quizId.value, size: 200),
      [quizId.value],
    );
    final sessions = quiz == null
        ? const <LearningSession>[]
        : ref.watch(watchLearningSessionsProvider(sessionParams)).value ??
              const <LearningSession>[];
    final session = sessions.where((s) => s.id == sessionId.value).firstOrNull;

    final from = int.tryParse(fromController.text) ?? 1;
    final to = int.tryParse(toController.text) ?? questions.length;

    final selected = switch (source.value) {
      SplitSource.range => QuizSplitter.byRange(questions, from, to),
      SplitSource.session =>
        session == null
            ? const <Question>[]
            : QuizSplitter.fromSession(session, sessionFilter.value),
      SplitSource.sharedCorrect => _unique(
        QuizAnalyzer.sharedCorrectAnswers(questions).expand((g) => g.questions),
        questions,
      ),
      SplitSource.confusable => _unique(
        QuizAnalyzer.correctUsedAsWrong(questions).expand((g) => g.questions),
        questions,
      ),
      SplitSource.phrases => _unique(
        QuizAnalyzer.uniqueCorrectPhrases(
          questions,
          limit: 1 << 30,
        ).expand((p) => p.questions),
        questions,
      ),
    };

    final defaultName = quiz == null
        ? ''
        : switch (source.value) {
            SplitSource.range => '${quiz.name} - câu $from-$to',
            SplitSource.session =>
              '${quiz.name} - ${sessionFilter.value.label.toLowerCase()}',
            _ =>
              '${quiz.name} - ${source.value.label.replaceFirst('Nhóm: ', '')}',
          };

    return ListView(
      children: [
        QuizDropdown(
          corpus: corpus,
          value: quizId.value,
          hint: "Chọn bộ đề nguồn",
          onChanged: (v) {
            quizId.value = v;
            sessionId.value = null;
          },
        ),
        const SizedBox(height: 16),
        if (quiz != null) ...[
          ToolSection(
            title: "Cách tách",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionDropdown<SplitSource>(
                  value: source.value,
                  values: SplitSource.values,
                  labelOf: (s) => s.label,
                  onChanged: (v) => source.value = v,
                ),
                const SizedBox(height: 12),
                if (source.value == SplitSource.range)
                  Row(
                    children: [
                      _NumberField(label: "Từ câu", controller: fromController),
                      const SizedBox(width: 12),
                      _NumberField(label: "Đến câu", controller: toController),
                      const SizedBox(width: 12),
                      Text("(bộ đề có ${questions.length} câu)"),
                    ],
                  ),
                if (source.value == SplitSource.session) ...[
                  OptionDropdown<int?>(
                    value: session?.id,
                    values: [null, ...sessions.map((s) => s.id)],
                    labelOf: (id) {
                      final s = sessions.where((s) => s.id == id).firstOrNull;
                      return s == null ? "Chọn phiên học" : _sessionLabel(s);
                    },
                    onChanged: (v) => sessionId.value = v,
                  ),
                  const SizedBox(height: 12),
                  OptionDropdown<SessionQuestionFilter>(
                    value: sessionFilter.value,
                    values: SessionQuestionFilter.values,
                    labelOf: (f) => f.label,
                    onChanged: (v) => sessionFilter.value = v,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          ToolSection(
            title: "Xem trước (${selected.length} câu)",
            child: QuestionPreviewList(questions: selected),
          ),
          const SizedBox(height: 16),
          SaveAsQuizPanel(
            corpus: corpus,
            questions: selected,
            defaultName: defaultName,
            defaultSubjectId: quiz.subject.target?.id,
          ),
        ],
      ],
    );
  }

  /// Bỏ trùng và giữ thứ tự như trong quiz gốc
  static List<Question> _unique(
    Iterable<Question> picked,
    List<Question> ordered,
  ) {
    final set = picked.toSet();
    return ordered.where(set.contains).toList();
  }

  static String _sessionLabel(LearningSession s) {
    final t = s.startTime;
    String two(int v) => v.toString().padLeft(2, '0');
    final mode = s.learningModeEnum.label;
    return '${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}'
        ' · $mode · đúng ${s.totalPass} / sai ${s.totalNotPass}';
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _NumberField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
