import 'package:frontend/features/library/models/quiz.dart';

class QuizExporter {
  static String exportToQuizletRaw(
    Quiz quiz, {
    String termDefSeparator = "\t",
    String rowSeparator = "\n",
  }) {
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];
      String questionContent = question.content.replaceAll('\n', ' ').trim();

      List<String> answerLines = [];
      List<String> correctLabels = [];

      for (int j = 0; j < question.answers.length; j++) {
        final ans = question.answers[j];
        final label = String.fromCharCode(65 + j);
        answerLines.add("$label. ${ans.content.replaceAll('\n', ' ').trim()}");
        if (ans.isCorrect) correctLabels.add(label);
      }

      String fullTerm = questionContent;
      if (answerLines.isNotEmpty) fullTerm += "\n${answerLines.join("\n")}";
      String definition = correctLabels.join(", ");

      buffer.write("$fullTerm$termDefSeparator$definition");
      if (i < quiz.questions.length - 1) buffer.write(rowSeparator);
    }
    return buffer.toString();
  }
}
