import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/utilities/services/quiz_analyzer.dart';
import 'package:frontend/features/utilities/widgets/tool_common.dart';

/// Tab "Phân tích": thống kê đáp án của 1 bộ đề (port từ analyze.py)
class AnalysisTab extends HookWidget {
  final SearchCorpus corpus;

  const AnalysisTab({super.key, required this.corpus});

  @override
  Widget build(BuildContext context) {
    final quizId = useState<int?>(null);
    final questions = quizId.value == null
        ? null
        : questionsOfQuiz(corpus, quizId.value!);
    final analysis = useMemoized(
      () => questions == null ? null : QuizAnalyzer.analyze(questions),
      [corpus, quizId.value],
    );

    return ListView(
      children: [
        QuizDropdown(
          corpus: corpus,
          value: quizId.value,
          onChanged: (v) => quizId.value = v,
        ),
        const SizedBox(height: 20),
        if (analysis == null)
          const Center(child: Text("Chọn 1 bộ đề để phân tích"))
        else
          ..._buildReport(analysis),
      ],
    );
  }

  List<Widget> _buildReport(QuizAnalysis a) {
    String percent(double v) => '${(v * 100).toStringAsFixed(1)}%';
    const gap = SizedBox(height: 16);

    return [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _StatCard("Tổng số câu", '${a.total}'),
          _StatCard("Câu 1 đáp án", '${a.singleCorrect}'),
          _StatCard("Câu nhiều đáp án", '${a.multiCorrect}'),
          _StatCard(
            "Câu chưa có đáp án đúng",
            '${a.noCorrect}',
            isWarning: a.noCorrect > 0,
          ),
        ],
      ),
      gap,
      ToolSection(
        title: "Vị trí đáp án đúng",
        subtitle: "Chỉ tính các câu có 1 đáp án đúng",
        child: _BarChart(
          values: a.positionDistribution,
          total: a.singleCorrect,
        ),
      ),
      gap,
      ToolSection(
        title: "Mẹo chọn đáp án",
        subtitle:
            "Chỉ tính câu 1 đáp án có đáp án dài/ngắn nhất duy nhất. "
            "Càng xa 1/(số đáp án) thì mẹo càng có ích.",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đáp án DÀI nhất là đáp án đúng: '
              '${a.longestIsCorrect.hits}/${a.longestIsCorrect.applicable} câu '
              '(${percent(a.longestIsCorrect.rate)})',
            ),
            const SizedBox(height: 6),
            Text(
              'Đáp án NGẮN nhất là đáp án đúng: '
              '${a.shortestIsCorrect.hits}/${a.shortestIsCorrect.applicable} câu '
              '(${percent(a.shortestIsCorrect.rate)})',
            ),
            if (a.longestCorrect != null) ...[
              const SizedBox(height: 12),
              Text(
                'Đáp án đúng dài nhất: "${a.longestCorrect!.content}"',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text('Đáp án đúng ngắn nhất: "${a.shortestCorrect!.content}"'),
            ],
          ],
        ),
      ),
      gap,
      ToolSection(
        title: "Cụm từ chỉ xuất hiện trong đáp án đúng",
        subtitle:
            "Cụm 2-3 từ xuất hiện ít nhất 2 lần trong đáp án đúng "
            "và không có trong đáp án sai nào",
        child: a.uniqueCorrectPhrases.isEmpty
            ? const Text("Không có")
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in a.uniqueCorrectPhrases)
                    Chip(label: Text('${p.phrase}  ×${p.count}')),
                ],
              ),
      ),
      gap,
      ToolSection(
        title: "Nhận diện câu qua đầu/cuối đáp án",
        subtitle:
            "Số câu có đáp án mà n từ đầu (prefix) hoặc n từ cuối (suffix) "
            "chỉ xuất hiện ở đúng câu đó",
        child: Table(
          border: TableBorder.all(color: LibraryColors.divider),
          columnWidths: const {0: FixedColumnWidth(70)},
          children: [
            _row([
              "Số từ",
              "Prefix độc nhất",
              "Suffix độc nhất",
              "Ít nhất 1",
              "%",
            ], isHeader: true),
            for (final s in a.affixStats)
              _row([
                '${s.wordCount}',
                '${s.questionsWithUniquePrefix}',
                '${s.questionsWithUniqueSuffix}',
                '${s.questionsWithEither}',
                a.total == 0 ? '-' : percent(s.questionsWithEither / a.total),
              ]),
          ],
        ),
      ),
      gap,
      _GroupSection(
        title: "Đáp án đúng bị dùng làm đáp án sai ở câu khác",
        subtitle:
            "Dễ nhầm lẫn: nội dung là đáp án đúng ở câu này nhưng sai ở câu khác",
        groups: a.correctUsedAsWrong,
      ),
      gap,
      _GroupSection(
        title: "Nhiều câu có chung đáp án đúng",
        groups: a.sharedCorrectAnswers,
      ),
    ];
  }

  TableRow _row(List<String> cells, {bool isHeader = false}) => TableRow(
    decoration: isHeader
        ? const BoxDecoration(color: LibraryColors.background)
        : null,
    children: [
      for (final c in cells)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            c,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
    ],
  );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isWarning;

  const _StatCard(this.label, this.value, {this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning ? AppColors.toastWarning : AppColors.toastInfo,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

/// Biểu đồ thanh ngang đơn giản: nhãn -> số lượng
class _BarChart extends StatelessWidget {
  final Map<String, int> values;
  final int total;

  const _BarChart({required this.values, required this.total});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const Text("Không có dữ liệu");
    final maxValue = values.values.reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        for (final e in values.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    e.key,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 22,
                        width: constraints.maxWidth * e.value / maxValue,
                        decoration: BoxDecoration(
                          color: AppColors.brandShadow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    '  ${e.value} (${(e.value / total * 100).toStringAsFixed(1)}%)',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Danh sách nhóm câu hỏi có thể mở rộng
class _GroupSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<QuestionGroup> groups;

  const _GroupSection({
    required this.title,
    this.subtitle,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final questionCount = groups.expand((g) => g.questions).toSet().length;
    return ToolSection(
      title: '$title (${groups.length} nhóm, $questionCount câu)',
      subtitle: subtitle,
      child: groups.isEmpty
          ? const Text("Không có")
          : Column(
              children: [
                for (final g in groups.take(30))
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      '"${g.key}"  →  ${g.questions.length} câu',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [QuestionPreviewList(questions: g.questions)],
                  ),
                if (groups.length > 30)
                  Text('... và ${groups.length - 30} nhóm khác'),
              ],
            ),
    );
  }
}
