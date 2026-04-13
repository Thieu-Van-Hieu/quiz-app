import 'package:flutter/material.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:intl/intl.dart';

class LearningResultItem extends StatelessWidget {
  final LearningSession session;
  final VoidCallback onTap;
  final VoidCallback onRetake;
  final VoidCallback? onCreateMistakeSession;
  final VoidCallback onDelete;

  const LearningResultItem({
    super.key,
    required this.session,
    required this.onTap,
    required this.onRetake,
    this.onCreateMistakeSession,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = session.isCompleted;
    final String formattedDate = DateFormat(
      'dd/MM HH:mm',
    ).format(session.startTime);

    // Xử lý hiển thị Tên môn + Tên Quiz
    String subjectName = "N/A";
    String quizName = "N/A";
    final quiz = session.quiz.target;
    if (quiz != null) {
      quizName = quiz.name;
      subjectName = quiz.subject.target?.name ?? "Môn học";
    }

    // Logic lấy phạm vi câu hỏi
    final List<int> allQuestionIdsInQuiz =
        quiz?.questions.map((q) => q.id).toList() ?? [];

    // 2. Logic lấy phạm vi câu hỏi dựa trên vị trí (index) trong Quiz
    final details = session.learningSessionDetails;
    String rangeText = "N/A";

    if (details.isNotEmpty && allQuestionIdsInQuiz.isNotEmpty) {
      final List<int> currentSessionIndices = details
          .map((d) {
            final qId = d.question.target?.id ?? 0;
            // Tìm vị trí của câu hỏi này trong danh sách tổng của Quiz (index + 1 = STT)
            final index = allQuestionIdsInQuiz.indexOf(qId);
            return index != -1 ? index + 1 : -1;
          })
          .where((stt) => stt > 0)
          .toList();

      if (currentSessionIndices.isNotEmpty) {
        currentSessionIndices.sort();
        rangeText =
            "Câu ${currentSessionIndices.first} - ${currentSessionIndices.last}";
      }
    }

    final isPracticeMode =
        session.learningMode == LearningMode.practice.toValue();
    final isStudyMode = session.learningMode == LearningMode.study.toValue();
    final isExamMode = session.learningMode == LearningMode.exam.toValue();

    final durationText = _formatTime(
      isExamMode ? (session.timeLimit ?? 0) * 60 : session.studyTime,
    );
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Ngày & Trạng thái
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildBadge(
                    isCompleted ? "HOÀN THÀNH" : "ĐANG LÀM",
                    isCompleted ? Colors.green : Colors.orange,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      enabledMouseCursor: SystemMouseCursors.click,
                      disabledMouseCursor: SystemMouseCursors.forbidden,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Tên Môn học (Phụ) & Tên Quiz (Chính)
              Text(
                subjectName.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                quizName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              const Divider(height: 24, thickness: 0.5),

              // 3. Thông tin chi tiết
              _buildInfoRow(Icons.tag, "Phạm vi:", rangeText),
              _buildInfoRow(
                Icons.layers_outlined,
                "Chế độ:",
                session.learningModeEnum.label,
              ),
              _buildInfoRow(Icons.timer_outlined, "Thời gian:", durationText),

              if (session.shuffleQuestions || session.shuffleAnswers)
                _buildInfoRow(
                  Icons.tune,
                  "Cấu hình:",
                  "${session.shuffleQuestions ? 'Trộn câu' : ''}${session.shuffleQuestions && session.shuffleAnswers ? ', ' : ''}${session.shuffleAnswers ? 'Trộn đáp án' : ''}",
                ),

              const Spacer(),

              // 4. Thống kê (Chỉ hiện khi đã xong)
              if (isCompleted) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatBox(
                        isPracticeMode ? "Xem" : "Đúng",
                        isPracticeMode
                            ? "${session.totalSeen}"
                            : "${session.totalCorrect}",
                        Colors.green,
                      ),
                      _buildStatBox(
                        isPracticeMode ? "Chưa xem" : "Sai",
                        isPracticeMode
                            ? "${session.learningSessionDetails.length - session.totalSeen}"
                            : "${session.totalWrong}",
                        Colors.red,
                      ),
                      _buildStatBox(
                        "Tổng",
                        "${details.length}",
                        Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 5. Nút bấm Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRetake,
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text(
                        "Làm lại",
                        style: TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade100),
                        enabledMouseCursor: SystemMouseCursors.click,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ),
                  if (isCompleted &&
                      session.totalWrong > 0 &&
                      !isPracticeMode) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCreateMistakeSession,
                        icon: const Icon(Icons.error_outline, size: 14),
                        label: const Text(
                          "Câu sai",
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red.shade700,
                          elevation: 0,
                          enabledMouseCursor: SystemMouseCursors.click,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds < 60) {
      return "${seconds.toInt()} giây";
    }
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = (seconds % 60).toInt();

    if (remainingSeconds == 0) {
      return "$minutes phút";
    }
    return "$minutes phút $remainingSeconds giây";
  }
}
