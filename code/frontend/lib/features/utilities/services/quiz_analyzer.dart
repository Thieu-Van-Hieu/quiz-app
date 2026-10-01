import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';

/// Một nhóm câu hỏi có chung đặc điểm (vd. cùng 1 đáp án đúng)
class QuestionGroup {
  final String key;
  final List<Question> questions;

  const QuestionGroup(this.key, this.questions);
}

/// Cụm từ chỉ xuất hiện trong đáp án đúng
class PhraseStat {
  final String phrase;
  final int count;
  final List<Question> questions;

  const PhraseStat(this.phrase, this.count, this.questions);
}

/// Thống kê prefix/suffix độc nhất với n từ đầu/cuối của đáp án
class AffixStat {
  final int wordCount;
  final int questionsWithUniquePrefix;
  final int questionsWithUniqueSuffix;
  final int questionsWithEither;

  const AffixStat({
    required this.wordCount,
    required this.questionsWithUniquePrefix,
    required this.questionsWithUniqueSuffix,
    required this.questionsWithEither,
  });
}

/// Tỉ lệ một mẹo chọn đáp án (vd. "chọn đáp án dài nhất") đúng
class HeuristicStat {
  final int applicable; // Số câu áp dụng được mẹo
  final int hits; // Số câu mẹo chọn đúng

  const HeuristicStat(this.applicable, this.hits);

  double get rate => applicable == 0 ? 0 : hits / applicable;
}

class QuizAnalysis {
  final int total;
  final int singleCorrect;
  final int multiCorrect;
  final int noCorrect;

  /// Số đáp án đúng -> số câu
  final Map<int, int> correctCountDistribution;

  /// Vị trí đáp án đúng (A, B, C...) của các câu 1 đáp án -> số câu
  final Map<String, int> positionDistribution;

  final HeuristicStat longestIsCorrect;
  final HeuristicStat shortestIsCorrect;

  final List<PhraseStat> uniqueCorrectPhrases;
  final List<AffixStat> affixStats;

  /// Đáp án đúng của câu này lại là đáp án sai ở câu khác (dễ nhầm)
  final List<QuestionGroup> correctUsedAsWrong;

  /// Nhiều câu có chung 1 đáp án đúng
  final List<QuestionGroup> sharedCorrectAnswers;

  final Answer? longestCorrect;
  final Answer? shortestCorrect;

  const QuizAnalysis({
    required this.total,
    required this.singleCorrect,
    required this.multiCorrect,
    required this.noCorrect,
    required this.correctCountDistribution,
    required this.positionDistribution,
    required this.longestIsCorrect,
    required this.shortestIsCorrect,
    required this.uniqueCorrectPhrases,
    required this.affixStats,
    required this.correctUsedAsWrong,
    required this.sharedCorrectAnswers,
    required this.longestCorrect,
    required this.shortestCorrect,
  });
}

/// Phân tích bộ đề (port từ utilities/analyze.py)
class QuizAnalyzer {
  static final _nonWord = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
  static final _spaces = RegExp(r'\s+');

  /// Chuẩn hoá để so sánh nội dung: chữ thường, bỏ dấu câu, gộp khoảng trắng
  static String normalize(String text) => text
      .toLowerCase()
      .replaceAll(_nonWord, ' ')
      .replaceAll(_spaces, ' ')
      .trim();

  static List<String> tokens(String text) {
    final normalized = normalize(text);
    return normalized.isEmpty ? const [] : normalized.split(' ');
  }

  static List<Answer> sortedAnswers(Question q) =>
      q.answers.toList()..sort((a, b) => a.indexOrder.compareTo(b.indexOrder));

  static String positionLabel(int index) => String.fromCharCode(65 + index);

  static QuizAnalysis analyze(
    List<Question> questions, {
    int maxPhrases = 20,
    List<int> affixWordCounts = const [3, 5, 7],
  }) {
    final countDistribution = <int, int>{};
    final positions = <String, int>{};
    var single = 0, multi = 0, none = 0;
    var longestApplicable = 0, longestHits = 0;
    var shortestApplicable = 0, shortestHits = 0;
    Answer? longestCorrect, shortestCorrect;

    for (final q in questions) {
      final answers = sortedAnswers(q);
      final correct = answers.where((a) => a.isCorrect).toList();
      countDistribution.update(correct.length, (v) => v + 1, ifAbsent: () => 1);

      if (correct.isEmpty) {
        none++;
      } else if (correct.length == 1) {
        single++;
        final label = positionLabel(answers.indexOf(correct.first));
        positions.update(label, (v) => v + 1, ifAbsent: () => 1);

        // Mẹo "chọn đáp án dài/ngắn nhất": chỉ tính khi đáp án dài/ngắn nhất là duy nhất
        if (answers.length >= 2) {
          final lengths = answers.map((a) => a.content.trim().length).toList();
          final maxLen = lengths.reduce((a, b) => a > b ? a : b);
          final minLen = lengths.reduce((a, b) => a < b ? a : b);
          if (lengths.where((l) => l == maxLen).length == 1) {
            longestApplicable++;
            if (correct.first.content.trim().length == maxLen) longestHits++;
          }
          if (lengths.where((l) => l == minLen).length == 1) {
            shortestApplicable++;
            if (correct.first.content.trim().length == minLen) shortestHits++;
          }
        }
      } else {
        multi++;
      }

      for (final a in correct) {
        final length = a.content.trim().length;
        if (length == 0) continue;
        if (longestCorrect == null ||
            length > longestCorrect.content.trim().length) {
          longestCorrect = a;
        }
        if (shortestCorrect == null ||
            length < shortestCorrect.content.trim().length) {
          shortestCorrect = a;
        }
      }
    }

    return QuizAnalysis(
      total: questions.length,
      singleCorrect: single,
      multiCorrect: multi,
      noCorrect: none,
      correctCountDistribution: Map.fromEntries(
        countDistribution.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      ),
      positionDistribution: Map.fromEntries(
        positions.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
      longestIsCorrect: HeuristicStat(longestApplicable, longestHits),
      shortestIsCorrect: HeuristicStat(shortestApplicable, shortestHits),
      uniqueCorrectPhrases: uniqueCorrectPhrases(questions, limit: maxPhrases),
      affixStats: [for (final n in affixWordCounts) _affixStat(questions, n)],
      correctUsedAsWrong: correctUsedAsWrong(questions),
      sharedCorrectAnswers: sharedCorrectAnswers(questions),
      longestCorrect: longestCorrect,
      shortestCorrect: shortestCorrect,
    );
  }

  /// Cụm 2-3 từ xuất hiện >= [minCount] lần trong đáp án đúng và KHÔNG xuất hiện trong đáp án sai nào
  static List<PhraseStat> uniqueCorrectPhrases(
    List<Question> questions, {
    int minCount = 2,
    int limit = 20,
  }) {
    Iterable<String> ngrams(String text) sync* {
      final words = tokens(text);
      for (final n in [2, 3]) {
        for (var i = 0; i + n <= words.length; i++) {
          yield words.sublist(i, i + n).join(' ');
        }
      }
    }

    final wrongNgrams = <String>{};
    final correctCounts = <String, int>{};
    final correctQuestions = <String, Set<Question>>{};

    for (final q in questions) {
      for (final a in q.answers) {
        if (a.isCorrect) {
          for (final gram in ngrams(a.content)) {
            correctCounts.update(gram, (v) => v + 1, ifAbsent: () => 1);
            correctQuestions.putIfAbsent(gram, () => {}).add(q);
          }
        } else {
          wrongNgrams.addAll(ngrams(a.content));
        }
      }
    }

    final result =
        correctCounts.entries
            .where((e) => e.value >= minCount && !wrongNgrams.contains(e.key))
            .map(
              (e) =>
                  PhraseStat(e.key, e.value, correctQuestions[e.key]!.toList()),
            )
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count));
    return result.take(limit).toList();
  }

  /// Prefix/suffix (n từ đầu/cuối của đáp án) chỉ xuất hiện trong đáp án của DUY NHẤT 1 câu
  /// -> nhìn đầu/cuối đáp án là nhận ra câu hỏi
  static AffixStat _affixStat(List<Question> questions, int n) {
    final prefixOwners = <String, Set<Question>>{};
    final suffixOwners = <String, Set<Question>>{};

    for (final q in questions) {
      for (final a in q.answers) {
        final words = tokens(a.content);
        if (words.isEmpty) continue;
        final prefix = words.take(n).join(' ');
        final suffix = words
            .skip(words.length > n ? words.length - n : 0)
            .join(' ');
        prefixOwners.putIfAbsent(prefix, () => {}).add(q);
        suffixOwners.putIfAbsent(suffix, () => {}).add(q);
      }
    }

    Set<Question> uniqueOwners(Map<String, Set<Question>> owners) => {
      for (final qs in owners.values)
        if (qs.length == 1) qs.first,
    };

    final withPrefix = uniqueOwners(prefixOwners);
    final withSuffix = uniqueOwners(suffixOwners);
    return AffixStat(
      wordCount: n,
      questionsWithUniquePrefix: withPrefix.length,
      questionsWithUniqueSuffix: withSuffix.length,
      questionsWithEither: withPrefix.union(withSuffix).length,
    );
  }

  /// Câu có đáp án đúng trùng nội dung với đáp án SAI của câu khác
  static List<QuestionGroup> correctUsedAsWrong(List<Question> questions) {
    final wrongOwners = <String, Set<Question>>{};
    for (final q in questions) {
      for (final a in q.answers.where((a) => !a.isCorrect)) {
        final key = normalize(a.content);
        if (key.isNotEmpty) wrongOwners.putIfAbsent(key, () => {}).add(q);
      }
    }

    final groups = <String, Set<Question>>{};
    for (final q in questions) {
      for (final a in q.answers.where((a) => a.isCorrect)) {
        final key = normalize(a.content);
        final others = wrongOwners[key]?.where((o) => o != q);
        if (others == null || others.isEmpty) continue;
        groups.putIfAbsent(a.content.trim(), () => {}).add(q);
      }
    }
    return [
      for (final e in groups.entries) QuestionGroup(e.key, e.value.toList()),
    ];
  }

  /// Nhiều câu khác nhau có chung 1 đáp án đúng
  static List<QuestionGroup> sharedCorrectAnswers(List<Question> questions) {
    final owners = <String, Set<Question>>{};
    final labels = <String, String>{};
    for (final q in questions) {
      for (final a in q.answers.where((a) => a.isCorrect)) {
        final key = normalize(a.content);
        if (key.isEmpty) continue;
        owners.putIfAbsent(key, () => {}).add(q);
        labels.putIfAbsent(key, () => a.content.trim());
      }
    }
    return [
      for (final e in owners.entries)
        if (e.value.length > 1) QuestionGroup(labels[e.key]!, e.value.toList()),
    ]..sort((a, b) => b.questions.length.compareTo(a.questions.length));
  }
}
