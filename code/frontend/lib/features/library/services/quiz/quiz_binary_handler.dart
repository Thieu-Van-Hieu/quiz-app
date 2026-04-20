import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizBinaryHandler {
  static Quiz importFromLegacyBinary(Uint8List bytes, String quizName) {
    final quiz = Quiz(name: quizName);
    final data = ByteData.sublistView(bytes);
    int offset = 0;
    try {
      int numberOfQuestions = data.getInt32(offset, Endian.little);
      offset += 4;
      for (int i = 0; i < numberOfQuestions; i++) {
        var result = _readBinaryQuestion(data, bytes, offset);
        quiz.questions.add(result.question);
        offset = result.newOffset;
      }
      return quiz;
    } catch (e) {
      throw Exception("Lỗi parse file Binary: $e");
    }
  }

  static ({Question question, int newOffset}) _readBinaryQuestion(
    ByteData data,
    Uint8List bytes,
    int offset,
  ) {
    var qText = _readNetString(data, bytes, offset);
    final question = Question(content: qText.text);
    int currentOffset = qText.newOffset;
    int numAnswers = data.getUint8(currentOffset++);
    for (int j = 0; j < numAnswers; j++) {
      var aText = _readNetString(data, bytes, currentOffset);
      currentOffset = aText.newOffset;
      bool isCorrect = data.getUint8(currentOffset++) != 0;
      question.answers.add(Answer(content: aText.text, isCorrect: isCorrect));
    }
    var exp = _readNetString(data, bytes, currentOffset);
    question.explanation = exp.text;
    question.syncAnswers();
    return (question: question, newOffset: exp.newOffset);
  }

  static ({String text, int newOffset}) _readNetString(
    ByteData data,
    Uint8List bytes,
    int offset,
  ) {
    int count = 0, shift = 0, current = offset;
    while (true) {
      int b = data.getUint8(current++);
      count |= (b & 0x7F) << shift;
      if ((b & 0x80) == 0) break;
      shift += 7;
    }
    if (count == 0) return (text: "", newOffset: current);
    String result = utf8.decode(bytes.sublist(current, current + count));
    return (text: result, newOffset: current + count);
  }
}
