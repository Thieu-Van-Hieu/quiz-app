import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

/// Một nhãn đáp án (A. B) ...) tìm thấy trong term
class _OptionLabel {
  final String letter; // Luôn viết hoa: A, B, C...
  final int start; // Vị trí bắt đầu nhãn
  final int end; // Vị trí bắt đầu nội dung đáp án

  _OptionLabel(this.letter, this.start, this.end);
}

class QuizTextParser {
  // Nhãn đáp án: 1 chữ cái A-H + "." hoặc ")" và phải có khoảng trắng / hết chuỗi phía sau.
  // Bắt buộc đứng đầu chuỗi hoặc sau khoảng trắng để không bắt nhầm "Marx-Lenin", "v.v.", "U.S.A"...
  static final _optionLabelRegex = RegExp(
    r'(?<=^|\s)([A-Ha-h])[.)](?=\s|$)',
    multiLine: true,
  );

  // Definition chỉ gồm nhãn: "A", "C.", "a)", "A, C", "A và C", "A; B; D"
  static final _pointerOnlyRegex = RegExp(
    r'^[A-Ha-h][.)]?(?:\s*(?:,|;|/|&|và|and)?\s*[A-Ha-h][.)]?)*$',
    caseSensitive: false,
  );

  // Definition bắt đầu bằng nhãn + nội dung: "A. Chủ nghĩa quốc tế vô sản"
  static final _labelPrefixRegex = RegExp(r'^([A-Ha-h])[.)]\s+');

  static const String errorFlag = "[ERR_FORMAT]";

  static void processFullBlock(
    String fullText,
    Quiz quiz, {
    String termDefSeparator = '\t',
  }) {
    String normalizeText(String input) {
      return input
          .replaceAll(' ', ' ') // Thay thế Non-breaking space bằng space thường
          .replaceAll('\r\n', '\n') // Chuẩn hóa Windows newline về Unix
          .replaceAll('\r', '\n') // Chuẩn hóa Mac newline về Unix
          .replaceAll(RegExp(r'\t'), ' ') // Thay Tab bằng space
          .trim();
    }

    final parts = smartSplit(fullText, termDefSeparator: termDefSeparator);
    final term = normalizeText(parts['term']!);
    final definition = normalizeText(parts['definition']!);

    final labels = _findOptionLabels(term);
    List<Answer> tempAnswers = [];
    List<String> tempLetters = [];
    String questionContent = "";
    String errorWarning = "";

    if (labels.isNotEmpty) {
      questionContent = term.substring(0, labels.first.start).trim();

      if (definition == "..." || definition.isEmpty) {
        errorWarning = "THIẾU ĐÁP ÁN ĐÚNG";
      }

      for (int j = 0; j < labels.length; j++) {
        final end = (j < labels.length - 1) ? labels[j + 1].start : term.length;
        final content = term.substring(labels[j].end, end).trim();

        // Tự động bỏ đáp án rỗng (giữ nhãn đi kèm để không lệch index)
        if (content.isEmpty) continue;
        tempAnswers.add(
          Answer(content: content, isCorrect: false, indexOrder: j),
        );
        tempLetters.add(labels[j].letter);
      }

      final isMatched = markCorrectAnswers(
        tempAnswers,
        tempLetters,
        definition,
      );
      if (!isMatched && errorWarning.isEmpty) {
        errorWarning = "KHÔNG KHỚP ĐÁP ÁN";
      }
    } else {
      questionContent = term;

      if (definition == "..." || definition.isEmpty) {
        errorWarning = "THIẾU ĐÁP ÁN FLASHCARD";
        tempAnswers.add(Answer(content: definition, isCorrect: false));
      } else {
        tempAnswers.add(Answer(content: definition, isCorrect: true));
      }

      if (term.length > 100) {
        errorWarning = "KIỂM TRA ĐỊNH DẠNG A.B.C.D";
      }
    }

    if (questionContent.isNotEmpty) {
      final finalExplanation = errorWarning.isNotEmpty
          ? "$errorFlag $errorWarning | Gốc: $definition"
          : definition;

      final question = Question(
        content: questionContent,
        explanation: finalExplanation,
      );
      question.answers.addAll(tempAnswers);
      question.syncAnswers();
      quiz.questions.add(question);
    }
  }

  static Map<String, String> smartSplit(
    String text, {
    String termDefSeparator = '\t',
  }) {
    if (text.contains(termDefSeparator)) {
      final idx = text.lastIndexOf(termDefSeparator);
      return {
        'term': text.substring(0, idx).trim(),
        'definition': text.substring(idx + termDefSeparator.length).trim(),
      };
    }
    final bigSpace = RegExp(r'\s{3,}');
    if (bigSpace.hasMatch(text)) {
      final matches = bigSpace.allMatches(text).toList();
      return {
        'term': text.substring(0, matches.last.start).trim(),
        'definition': text.substring(matches.last.end).trim(),
      };
    }
    return {'term': text, 'definition': '...'};
  }

  /// Tìm các nhãn đáp án hợp lệ trong term.
  /// Nhãn phải liên tiếp theo thứ tự A, B, C... Nếu có nhiều chuỗi (vd. "Vitamin A. ..." trong câu hỏi),
  /// chọn chuỗi dài nhất, bằng nhau thì lấy chuỗi xuất hiện sau cùng.
  /// Ưu tiên nhãn đứng đầu dòng (định dạng mỗi đáp án 1 dòng).
  static List<_OptionLabel> _findOptionLabels(String term) {
    final all = _optionLabelRegex.allMatches(term).map((m) {
      return _OptionLabel(m.group(1)!.toUpperCase(), m.start, m.end);
    }).toList();

    bool isLineStart(_OptionLabel l) =>
        l.start == 0 || term.substring(0, l.start).endsWith('\n');

    final lineStartSeq = _longestSequence(all.where(isLineStart).toList());
    if (lineStartSeq.length >= 2) return lineStartSeq;

    final seq = _longestSequence(all);
    return seq.length >= 2 ? seq : [];
  }

  static List<_OptionLabel> _longestSequence(List<_OptionLabel> candidates) {
    List<_OptionLabel> best = [];
    for (int i = 0; i < candidates.length; i++) {
      if (candidates[i].letter != 'A') continue;

      final seq = [candidates[i]];
      for (int j = i + 1; j < candidates.length; j++) {
        final expected = String.fromCharCode(seq.last.letter.codeUnitAt(0) + 1);
        if (candidates[j].letter == expected) seq.add(candidates[j]);
      }
      if (seq.length >= best.length) best = seq;
    }
    return best;
  }

  static String _normalizeForCompare(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[\s.,;:!?]+$'), '')
        .trim();
  }

  /// Đánh dấu đáp án đúng dựa vào definition. Trả về false nếu không khớp được đáp án nào.
  static bool markCorrectAnswers(
    List<Answer> answers,
    List<String> letters,
    String definition,
  ) {
    final trimmedDef = definition.trim();
    if (trimmedDef == "..." || trimmedDef.isEmpty) return false;

    bool markByLetters(Iterable<String> targetLetters) {
      bool found = false;
      for (final letter in targetLetters) {
        final i = letters.indexOf(letter);
        if (i != -1) {
          answers[i].isCorrect = true;
          found = true;
        }
      }
      return found;
    }

    // 1. Definition chỉ gồm nhãn: "A", "A, C"
    if (_pointerOnlyRegex.hasMatch(trimmedDef)) {
      final pointerLetters = RegExp(
        r'\b([A-Ha-h])\b',
      ).allMatches(trimmedDef).map((m) => m.group(1)!.toUpperCase()).toSet();
      if (markByLetters(pointerLetters)) return true;
    }

    // 2. Definition dạng "A. nội dung": tách nhãn ra khỏi nội dung
    final prefixMatch = _labelPrefixRegex.firstMatch(trimmedDef);
    final prefixLetter = prefixMatch?.group(1)!.toUpperCase();
    final contentDef = prefixMatch != null
        ? trimmedDef.substring(prefixMatch.end)
        : trimmedDef;

    // 3. So khớp nội dung CHÍNH XÁC (sau khi chuẩn hoá). Hỗ trợ nhiều đáp án cách nhau bởi xuống dòng / ";"
    final defParts = {
      _normalizeForCompare(contentDef),
      ...contentDef.split(RegExp(r'\n|;')).map(_normalizeForCompare),
    }..removeWhere((p) => p.isEmpty);

    bool foundExact = false;
    for (final ans in answers) {
      if (defParts.contains(_normalizeForCompare(ans.content))) {
        ans.isCorrect = true;
        foundExact = true;
      }
    }
    if (foundExact) return true;

    // 4. Có nhãn ở đầu definition nhưng nội dung không khớp chính xác -> tin vào nhãn
    if (prefixLetter != null && markByLetters([prefixLetter])) return true;

    // 5. Khớp gần đúng: chỉ chọn DUY NHẤT 1 đáp án có độ trùng dài nhất
    //    (definition chứa đáp án hoặc đáp án chứa definition)
    final normDef = _normalizeForCompare(contentDef);
    int bestIndex = -1;
    int bestScore = 0;
    bool isTie = false;
    for (int i = 0; i < answers.length; i++) {
      final normAns = _normalizeForCompare(answers[i].content);
      if (normAns.length <= 3) continue;

      int score = 0;
      if (normDef.contains(normAns)) {
        score = normAns.length;
      } else if (normAns.contains(normDef) && normDef.length > 3) {
        score = normDef.length;
      }

      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
        isTie = false;
      } else if (score > 0 && score == bestScore) {
        isTie = true;
      }
    }

    if (bestIndex != -1 && !isTie) {
      answers[bestIndex].isCorrect = true;
      return true;
    }

    return false;
  }
}
