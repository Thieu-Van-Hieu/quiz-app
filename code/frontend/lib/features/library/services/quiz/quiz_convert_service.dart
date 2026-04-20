import 'dart:typed_data';

import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/services/quiz/quiz_binary_handler.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';
import 'package:frontend/features/library/services/quiz/quiz_exporter.dart';
import 'package:frontend/features/library/services/quiz/quiz_text_parser.dart';

class QuizConverterService {
  static String exportQuizToJson(Quiz quiz) => quiz.toJson();

  static Quiz importAsNew(String jsonString) {
    return _prepareForImport(Quiz.fromJson(jsonString));
  }

  static List<Question> convertRawOcrToQuestions(String rawText) {
    final quiz = Quiz(name: "OCR_Import");
    final lines = rawText.split('\n');
    StringBuffer normalizedBuffer = StringBuffer();
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (RegExp(r'^(\d+|Câu\s*\d+)[.:)\-\s]').hasMatch(trimmed)) {
        normalizedBuffer.write('\n$trimmed');
      } else {
        normalizedBuffer.write(' $trimmed');
      }
    }

    final blocks = normalizedBuffer.toString().split(
      RegExp(r'\n(?=\d+|Câu\s*\d+)'),
    );
    for (var block in blocks) {
      final cleanBlock = block.trim();
      if (cleanBlock.isEmpty) continue;
      QuizTextParser.processFullBlock("$cleanBlock\t...", quiz);
    }
    return quiz.questions;
  }

  static Quiz convertQuizletToQuiz(
    String quizletRaw, {
    String quizName = "New Quizlet",
    String termDefSeparator = "\t",
    String rowSeparator = "\n",
  }) {
    final quiz = Quiz(name: quizName);
    final lines = quizletRaw.split('\n');
    StringBuffer currentBlock = StringBuffer();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (currentBlock.isEmpty) {
        currentBlock.write(line);
      } else {
        currentBlock.write("\n$line");
      }
      if (line.contains(termDefSeparator) || i == lines.length - 1) {
        QuizTextParser.processFullBlock(currentBlock.toString(), quiz);
        currentBlock.clear();
      }
    }

    // TASK: Lọc trùng nâng cao
    final Map<String, Question> uniqueQuestions = {};

    for (var q in quiz.questions) {
      final fingerprint = QuizDeduplicator.createFingerprint(q);

      // Nếu chưa tồn tại trong Map thì thêm vào
      if (!uniqueQuestions.containsKey(fingerprint)) {
        uniqueQuestions[fingerprint] = q;
      } else {
        // Log hoặc debug nếu cần: print("Đã tìm thấy câu trùng và bỏ qua: ${q.content}");
      }
    }
    return _prepareForImport(quiz);
  }

  static Quiz importFromLegacyBinary(
    Uint8List bytes, {
    String quizName = "Legacy Quiz",
  }) {
    return _prepareForImport(
      QuizBinaryHandler.importFromLegacyBinary(bytes, quizName),
    );
  }

  static String exportToQuizletRaw(
    Quiz quiz, {
    String termDefSeparator = "\t",
    String rowSeparator = "\n",
  }) {
    return QuizExporter.exportToQuizletRaw(
      quiz,
      termDefSeparator: termDefSeparator,
      rowSeparator: rowSeparator,
    );
  }

  static Quiz _prepareForImport(Quiz quiz) {
    quiz.id = 0;
    for (var q in quiz.questions) {
      q.id = 0;
      q.quiz.target = quiz;
      for (var a in q.answers) {
        a.id = 0;
        a.question.target = q;
      }
    }
    return quiz;
  }
}
