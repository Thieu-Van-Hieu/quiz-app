import 'dart:convert';
import 'dart:typed_data';

import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';

class QuizConverterService {
  static const String errorFlag = "[ERR_FORMAT]";
  static final _optionLabelRegex = RegExp(r'([A-Z])[.)\-\s]\s+');

  // --- 1. JSON EXPORT & IMPORT (Giữ nguyên) ---
  static String exportQuizToJson(Quiz quiz) => quiz.toJson();

  static Quiz importAsNew(String jsonString) {
    try {
      final quiz = Quiz.fromJson(jsonString);
      return _prepareForImport(quiz);
    } catch (e) {
      throw Exception("Lỗi định dạng JSON: $e");
    }
  }

  // --- 2. OCR IMPORT ENGINE (MỚI THÊM) ---
  /// Nhận text thô từ OCR, xử lý gộp dòng và băm thành List Question
  static List<Question> convertRawOcrToQuestions(String rawText) {
    final quiz = Quiz(name: "OCR_Import");

    // 1. Tiền xử lý: OCR thường xuống dòng lỗi.
    // Ta gộp các dòng lại, chỉ xuống dòng thật sự khi bắt đầu bằng số (Câu mới)
    final lines = rawText.split('\n');
    StringBuffer normalizedBuffer = StringBuffer();
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // Nếu dòng bắt đầu bằng số (VD: "1.", "Câu 1:") thì mới xuống dòng mới
      if (RegExp(r'^(\d+|Câu\s*\d+)[.:)\-\s]').hasMatch(trimmed)) {
        normalizedBuffer.write('\n$trimmed');
      } else {
        normalizedBuffer.write(' $trimmed');
      }
    }

    // 2. Tách khối dựa trên số thứ tự câu hỏi
    final blocks = normalizedBuffer.toString().split(
      RegExp(r'\n(?=\d+|Câu\s*\d+)'),
    );

    for (var block in blocks) {
      final cleanBlock = block.trim();
      if (cleanBlock.isEmpty) continue;

      // Đẩy vào logic xử lý block với definition mặc định là "..."
      // Điều này sẽ kích hoạt errorFlag vì thiếu đáp án đúng, giúp UI dễ lọc
      _processFullBlock("$cleanBlock\t...", quiz);
    }

    return quiz.questions;
  }

  // --- 3. QUIZLET / TEXT IMPORT ENGINE ---
  static Quiz convertQuizletToQuiz(
    String quizletRaw, {
    String quizName = "New Quizlet",
    String termDefSeparator = "\t",
    String rowSeparator = "\n",
  }) {
    final quiz = Quiz(name: quizName);

    // Giữ nguyên logic tách hàng cũ nhưng thay đổi cách nối dòng
    final lines = quizletRaw.split('\n');
    StringBuffer currentBlock = StringBuffer();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i]; // Không trim ở đây để giữ cấu trúc dòng

      if (currentBlock.isEmpty) {
        currentBlock.write(line);
      } else {
        currentBlock.write("\n$line");
      }

      // Kiểm tra nếu dòng hiện tại kết thúc 1 khối (chứa termDefSeparator)
      if (line.contains(termDefSeparator) || i == lines.length - 1) {
        _processFullBlock(currentBlock.toString(), quiz);
        currentBlock.clear();
      }
    }

    return _prepareForImport(quiz);
  }

  static void _processFullBlock(String fullText, Quiz quiz) {
    final parts = _smartSplit(fullText);
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

  static Map<String, String> _smartSplit(String text) {
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

    // 1. Kiểm tra so khớp nội dung text (Text Match)
    // Dùng cho trường hợp định nghĩa ghi rõ nội dung đáp án
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
        // Nếu khớp theo text thì thường là single choice, nhưng vẫn cho chạy tiếp
      }
    }

    // 2. Kiểm tra so khớp theo Nhãn (Label Match - VD: "A, B" hoặc "ACD")
    // Nếu kịch bản 1 chưa tìm thấy hoặc định nghĩa ngắn (dạng ký tự đại diện)
    if (!foundAtLeastOne || defUpper.length < 5) {
      // Tách các ký tự nhãn từ định nghĩa (Ví dụ: "A, B, C" -> ["A", "B", "C"])
      // Regex này bắt tất cả các chữ cái đứng đơn lẻ
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

  // --- 4. BINARY IMPORT (Giữ nguyên) ---
  static Quiz importFromLegacyBinary(
    Uint8List bytes, {
    String quizName = "Legacy Quiz",
  }) {
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
      return _prepareForImport(quiz);
    } catch (e) {
      throw Exception("Lỗi parse file Binary: $e");
    }
  }

  // --- 5. EXPORT TO QUIZLET ---
  /// Chuyển đổi Quiz sang định dạng văn bản để có thể Copy-Paste vào Quizlet
  static String exportToQuizletRaw(
    Quiz quiz, {
    String termDefSeparator =
        "\t", // Phân tách giữa mặt trước (Term) và mặt sau (Def)
    String rowSeparator = "\n", // Phân tách giữa các câu hỏi
  }) {
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < quiz.questions.length; i++) {
      final question = quiz.questions[i];

      // 1. Xử lý nội dung câu hỏi (vẫn làm phẳng để tránh gãy hàng)
      String questionContent = question.content.replaceAll('\n', ' ').trim();

      List<String> answerLines = [];
      List<String> correctLabels = [];

      for (int j = 0; j < question.answers.length; j++) {
        final ans = question.answers[j];
        final label = String.fromCharCode(65 + j);

        // Tách từng đáp án xuống dòng mới
        answerLines.add("$label. ${ans.content.replaceAll('\n', ' ').trim()}");

        if (ans.isCorrect) correctLabels.add(label);
      }

      // 2. Gom Term: Câu hỏi -> Xuống dòng -> Các lựa chọn
      String fullTerm = questionContent;
      if (answerLines.isNotEmpty) {
        // Sử dụng \n thực sự ở đây để tách dòng các đáp án bên trong 1 Term
        fullTerm += "\n${answerLines.join("\n")}";
      }

      // 3. Definition: Đáp án đúng (ví dụ: A, B)
      String definition = correctLabels.join(", ");

      // 4. Ghép lại: [Câu hỏi + Đáp án các dòng] [TAB] [Đáp án đúng]
      buffer.write("$fullTerm$termDefSeparator$definition");

      // Nếu chưa phải câu cuối thì mới thêm rowSeparator để sang câu tiếp theo
      if (i < quiz.questions.length - 1) {
        buffer.write(rowSeparator);
      }
    }
    return buffer.toString();
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
