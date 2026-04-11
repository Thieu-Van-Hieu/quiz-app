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
      color: const Color(0xFFD4D0C8),
      padding: const EdgeInsets.all(1),
      alignment: Alignment.topLeft, // Neo vào góc trái
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          // CHỐT CHẶN: Ép chiều ngang tối đa bằng màn hình
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 2,
          ),
          child: IntrinsicWidth(
            // CƠ CHẾ CO GIÃN: Tự co theo nội dung bên trong
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 500, // Bắt buộc chiều rộng tối thiểu là 500px
              ),
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Text Câu hỏi (Sẽ tự wrap khi đụng maxWidth của ConstrainedBox)
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
                    final label = String.fromCharCode(65 + index);
                    final status = _getAnswerStatus(answer);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        // Quan trọng: Row không chiếm hết chỗ
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sử dụng Flexible thay vì Expanded để hỗ trợ IntrinsicWidth tốt hơn
                          Flexible(
                            child: Text(
                              "$label. ${answer.content}",
                              style: TextStyle(
                                fontSize: fontSize,
                                fontFamily: fontFamily,
                                color: (status == AnswerStatus.correct)
                                    ? Colors.green.shade700
                                    : Colors.black,
                              ),
                            ),
                          ),
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

                  // 3. Explanation... (tương tự nội dung câu hỏi)
                  if (showAnswer && question.explanation.isNotEmpty) ...[
                    const Divider(thickness: 1),
                    Text(
                      question.explanation,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontStyle: FontStyle.italic,
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
