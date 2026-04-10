import 'package:flutter/material.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';

enum AnswerStatus { none, correct, incorrect }

class EosQuestionContent extends StatelessWidget {
  final double fontSize;
  final String fontFamily;
  final LearningSessionDetail learningSessionDetail;
  final bool showAnswer;

  const EosQuestionContent({
    super.key,
    required this.fontSize,
    required this.fontFamily,
    required this.learningSessionDetail,
    this.showAnswer = false,
  });

  /// Hàm helper quyết định trạng thái hiển thị của từng đáp án
  /// Dựa trên session type (Practice/Study/Exam) và lựa chọn của người dùng
  AnswerStatus _getAnswerStatus(Answer answer) {
    if (!showAnswer) return AnswerStatus.none;

    final session = learningSessionDetail.learningSession.target;
    final sessionType = session?.learningMode ?? 'practice';
    final selectedAnswers = learningSessionDetail.selectedAnswers;

    // 1. Chế độ PRACTICE: Chỉ quan tâm đáp án hệ thống đánh dấu là đúng
    if (sessionType == 'practice') {
      return answer.isCorrect ? AnswerStatus.correct : AnswerStatus.none;
    }

    // 2. Chế độ STUDY / EXAM / TEST: So sánh với lựa chọn thực tế của người dùng
    final isUserSelected = selectedAnswers.any((a) => a.id == answer.id);

    if (answer.isCorrect) {
      // Luôn hiện tích xanh cho đáp án đúng khi đã Reveal
      return AnswerStatus.correct;
    } else if (isUserSelected) {
      // Chỉ hiện X đỏ nếu người dùng chọn và đáp án đó sai
      return AnswerStatus.incorrect;
    }

    return AnswerStatus.none;
  }

  @override
  Widget build(BuildContext context) {
    final question = learningSessionDetail.question.target;
    if (question == null) return const SizedBox.shrink();

    return Container(
      color: const Color(0xFFD4D0C8), // Màu nền bao quanh retro
      padding: const EdgeInsets.all(1),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: IntrinsicWidth(
            child: Container(
              constraints: const BoxConstraints(minWidth: 500),
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Nội dung câu hỏi
                  Text(
                    question.content,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: fontFamily,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 2. Danh sách đáp án
                  ...question.answers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final answer = entry.value;
                    final label = String.fromCharCode(
                      65 + index,
                    ); // A, B, C, D...

                    final status = _getAnswerStatus(answer);
                    final isUserSelected = learningSessionDetail.selectedAnswers
                        .any((a) => a.id == answer.id);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$label. ${answer.content}",
                            style: TextStyle(
                              fontSize: fontSize,
                              fontFamily: fontFamily,
                              // Highlight đậm nếu là đáp án người dùng chọn
                              fontWeight: isUserSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              // Đổi màu xanh nếu là đáp án đúng và đang show kết quả
                              color: (status == AnswerStatus.correct)
                                  ? Colors.green.shade700
                                  : Colors.black,
                            ),
                          ),

                          // Icon Trạng thái (Tích xanh / X đỏ)
                          if (status != AnswerStatus.none) ...[
                            const SizedBox(width: 10),
                            Icon(
                              status == AnswerStatus.correct
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: status == AnswerStatus.correct
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    );
                  }),

                  // 3. Phần Giải thích (Explanation) - Hiện theo Template ảnh
                  if (showAnswer && question.explanation.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 10),
                    Text(
                      "Explanation:",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      question.explanation,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: fontFamily,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
