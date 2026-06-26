import 'package:flutter/cupertino.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizTextParser {
  // Chuẩn hóa regex bắt các nhãn đáp án (A. B. C) không phân biệt hoa thường
  static final _optionLabelRegex = RegExp(
    r'([A-Za-z])(?:\.|[)\-])\s*',
    caseSensitive: false,
  );

  static const String errorFlag = "[ERR_FORMAT]";

  static void processFullBlock(String fullText, Quiz quiz) {
    String normalizeText(String input) {
      return input
          .replaceAll(
            '\u00A0',
            ' ',
          ) // Thay thế Non-breaking space bằng space thường
          .replaceAll('\r\n', '\n') // Chuẩn hóa Windows newline về Unix
          .replaceAll('\r', '\n') // Chuẩn hóa Mac newline về Unix
          .replaceAll(RegExp(r'\t'), ' ') // Thay Tab bằng space
          .trim();
    }

    final parts = smartSplit(fullText);
    // Đã sửa: Gom việc lấy dữ liệu và normalize vào làm một để tránh trùng biến
    final term = normalizeText(parts['term']!);
    final definition = normalizeText(parts['definition']!);

    debugPrint("DEBUG PARSE DEFINITION: $definition");
    debugPrint("DEBUG STRING CODES:");
    debugPrint(term.runes.map((r) => r.toRadixString(16)).join(' '));

    final matches = _optionLabelRegex.allMatches(term).toList();
    List<Answer> tempAnswers = [];
    String questionContent = "";
    String errorWarning = "";

    if (matches.isNotEmpty) {
      questionContent = term.substring(0, matches.first.start).trim();

      if (definition == "..." || definition.isEmpty) {
        errorWarning = "THIẾU ĐÁP ÁN ĐÚNG";
      }

      for (int j = 0; j < matches.length; j++) {
        int start = matches[j].start;
        int end = (j < matches.length - 1) ? matches[j + 1].start : term.length;
        String content = term
            .substring(start, end)
            .replaceFirst(_optionLabelRegex, '')
            .trim();
        tempAnswers.add(Answer(content: content, isCorrect: false));
      }

      // Tự động bỏ đáp án rỗng
      tempAnswers = tempAnswers
          .where((a) => a.content.trim().isNotEmpty)
          .toList();

      bool isMatched = _markCorrectAnswer(tempAnswers, definition, matches);
      if (!isMatched && errorWarning.isEmpty) {
        errorWarning = "KHÔNG KHỚP ĐÁP ÁN";
      }
    } else {
      debugPrint(
        "Regex không tìm thấy match nào. String hiện tại: ${term.length > 20 ? term.substring(0, 20) : term}...",
      );
      questionContent = term;

      if (definition == "..." || definition.isEmpty) {
        errorWarning = "THIẾU ĐÁP ÁN FLASHCARD";
        tempAnswers.add(Answer(content: definition, isCorrect: false));
      } else {
        tempAnswers.add(Answer(content: definition, isCorrect: true));
      }

      if (term.length > 100 && !term.contains(_optionLabelRegex)) {
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

  static Map<String, String> smartSplit(String text) {
    if (text.contains('\t')) {
      int idx = text.lastIndexOf('\t');
      return {
        'term': text.substring(0, idx).trim(),
        'definition': text.substring(idx).trim(),
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
    if (text.contains(' - ')) {
      int idx = text.lastIndexOf(' - ');
      return {
        'term': text.substring(0, idx).trim(),
        'definition': text.substring(idx + 3).trim(),
      };
    }
    return {'term': text, 'definition': '...'};
  }

  static bool _markCorrectAnswer(
    List<Answer> answers,
    String definition,
    List<RegExpMatch> matches,
  ) {
    if (definition == "..." || definition.trim().isEmpty) return false;
    final trimmedDef = definition.trim();
    bool foundAtLeastOne = false;

    // 1. ƯU TIÊN CAO NHẤT: Kiểm tra dạng pointer trực tiếp (ví dụ: "A", "C.", "b)")
    final pointerRegex = RegExp(r'^([A-Da-d])[.)\-\s]*$');
    final pointerMatch = pointerRegex.firstMatch(trimmedDef);

    if (pointerMatch != null) {
      final label = pointerMatch.group(1)!.toUpperCase();
      for (int i = 0; i < matches.length; i++) {
        final optionLabel = matches[i].group(1)!.toUpperCase();
        if (optionLabel == label && i < answers.length) {
          answers[i].isCorrect = true;
          return true;
        }
      }
    }

    // 2. NẾU KHÔNG PHẢI POINTER: So sánh nội dung chữ (Content Match)
    final cleanDef = definition
        .replaceFirst(
          _optionLabelRegex,
          '',
        ) // Xóa nhãn nếu lỡ dính trong definition
        .trim()
        .toUpperCase();

    for (var ans in answers) {
      final ansUpper = ans.content.toUpperCase();
      if (ansUpper.isNotEmpty &&
          (ansUpper == cleanDef ||
              (cleanDef.contains(ansUpper) && ansUpper.length > 3))) {
        ans.isCorrect = true;
        foundAtLeastOne = true;
      }
    }

    // 3. FALLBACK: Nếu vẫn không khớp nội dung, tìm ký tự [A-D] ẩn lẩn khuất bên trong definition
    if (!foundAtLeastOne) {
      final labelInDef = RegExp(
        r'[A-D]',
        caseSensitive: false,
      ).allMatches(trimmedDef).map((m) => m.group(0)!.toUpperCase()).toSet();

      for (int i = 0; i < matches.length; i++) {
        String labelInQuestion = matches[i].group(1)!.toUpperCase();
        if (labelInDef.contains(labelInQuestion) && i < answers.length) {
          answers[i].isCorrect = true;
          foundAtLeastOne = true;
        }
      }
    }

    return foundAtLeastOne;
  }
}
