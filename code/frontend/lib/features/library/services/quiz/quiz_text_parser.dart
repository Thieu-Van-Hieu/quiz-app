import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizTextParser {
  static final _optionLabelRegex = RegExp(r'([A-Z])[.)\-\s]\s+');
  static const String errorFlag = "[ERR_FORMAT]";

  static void processFullBlock(String fullText, Quiz quiz) {
    final parts = smartSplit(fullText);
    final term = parts['term']!;
    final definition = parts['definition']!;

    final matches = _optionLabelRegex.allMatches(term).toList();
    List<Answer> tempAnswers = [];
    String questionContent = "";
    String errorWarning = "";

    if (matches.isNotEmpty) {
      questionContent = term.substring(0, matches.first.start).trim();

      if (definition == "..." || definition.trim().isEmpty) {
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

      // Tự động bỏ đáp án rỗng (khoảng trắng cũng được coi là rỗng)
      tempAnswers = tempAnswers
          .where((a) => a.content.trim().isNotEmpty)
          .toList();

      bool isMatched = _markCorrectAnswer(tempAnswers, definition, matches);
      if (!isMatched && errorWarning.isEmpty) {
        errorWarning = "KHÔNG KHỚP ĐÁP ÁN";
      }
    } else {
      questionContent = term;
      if (definition == "..." || definition.trim().isEmpty) {
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
    final defUpper = definition.trim().toUpperCase();
    bool foundAtLeastOne = false;
    final cleanDef = definition
        .replaceFirst(_optionLabelRegex, '')
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

    if (!foundAtLeastOne || defUpper.length < 5) {
      final labelInDef = RegExp(
        r'[A-Z]',
      ).allMatches(defUpper).map((m) => m.group(0)).toList();
      for (int i = 0; i < matches.length; i++) {
        String labelInQuestion = matches[i].group(1)!.toUpperCase();
        if (labelInDef.contains(labelInQuestion)) {
          answers[i].isCorrect = true;
          foundAtLeastOne = true;
        }
      }
    }
    return foundAtLeastOne;
  }
}
