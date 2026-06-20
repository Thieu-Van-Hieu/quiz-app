import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:intl/intl.dart';

class LearningResultCard extends StatelessWidget {
  final LearningSession session;
  final VoidCallback onTap;
  final VoidCallback onRetake;
  final VoidCallback? onCreateMistakeSession;
  final VoidCallback onDelete;

  const LearningResultCard({
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

    // Logic lấy phạm vi câu hỏi dựa trên vị trí (index) trong Quiz
    final List<int> allQuestionIdsInQuiz =
        quiz?.questions.map((q) => q.id).toList() ?? [];
    final details = session.learningSessionDetails;
    String rangeText = "N/A";

    if (details.isNotEmpty && allQuestionIdsInQuiz.isNotEmpty) {
      final List<int> currentSessionIndices = details
          .map((d) {
            final qId = d.question.target?.id ?? 0;
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
    final isExamMode = session.learningMode == LearningMode.exam.toValue();

    final durationText = _formatTime(
      isExamMode ? (session.timeLimit ?? 0) * 60 : session.studyTime,
    );

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        mouseCursor: SystemMouseCursors.click,
        // ✅ GIẢI PHÁP: Bọc IntrinsicHeight giúp Column nhận biết được chiều cao tối đa để sử dụng Spacer() hợp lệ
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Ngày & Trạng thái & Nút Xóa
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _buildBadge(
                      isCompleted ? "HOÀN THÀNH" : "ĐANG LÀM",
                      isCompleted
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFF97316),
                    ),
                    const SizedBox(width: 8),
                    AppActionButton(
                      onTap: onDelete,
                      actionType: ActionType.delete,
                      style: ActionButtonStyle.tonal,
                      tooltip: "Xóa lượt học này",
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2. Tên Môn học & Tên Quiz
                Text(
                  subjectName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D4ED8),
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
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Divider(
                  height: 24,
                  thickness: 0.5,
                  color: Color(0xFFE2E8F0),
                ),

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

                const SizedBox(height: 12),

                // 4. Thống kê (Chỉ hiện khi đã xong)
                if (isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatBox(
                          isPracticeMode ? "Xem" : "Đúng",
                          isPracticeMode
                              ? "${session.totalSeen}"
                              : "${session.totalCorrect}",
                          const Color(0xFF22C55E),
                        ),
                        _buildStatBox(
                          isPracticeMode ? "Chưa xem" : "Sai",
                          isPracticeMode
                              ? "${session.learningSessionDetails.length - session.totalSeen}"
                              : "${session.totalWrong}",
                          const Color(0xFFEF4444),
                        ),
                        _buildStatBox(
                          "Tổng",
                          "${details.length}",
                          const Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ],

                // ✅ THAY ĐỔI CỐT LÕI: Đẩy toàn bộ các nút bấm Actions xuống đáy tuyệt đối của Card
                const Spacer(),
                const SizedBox(height: 12),

                // 5. Nút bấm Actions cố định dưới đáy
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: onRetake,
                        label: "Làm lại",
                        icon: Icons.refresh,
                        variant: ButtonVariant.brandOutlined,
                        size: ButtonSize.small,
                      ),
                    ),
                    if (isCompleted &&
                        session.totalWrong > 0 &&
                        !isPracticeMode) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          onPressed: onCreateMistakeSession,
                          label: "Câu sai",
                          icon: Icons.error_outline,
                          variant: ButtonVariant.danger,
                          size: ButtonSize.small,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
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
          Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
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
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          letterSpacing: 0.3,
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
