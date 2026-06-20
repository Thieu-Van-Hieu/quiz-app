import 'package:flutter/material.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:intl/intl.dart';

class RecentSessionCard extends StatelessWidget {
  final LearningSession session;
  final VoidCallback onTap;

  const RecentSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPractice = session.learningModeEnum == LearningMode.practice;
    final accuracyColor = _getAccuracyColor(session.accuracyRate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Sử dụng InkWell nguyên bản bên trong Container để có hiệu ứng gợn sóng (Ripple Effect) khi click chuẩn UI cao cấp
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Khối Icon trạng thái - Được bo tròn tinh tế đồng bộ với ButtonStyle Tonal
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accuracyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: accuracyColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),

              // Nội dung Text thông tin phiên học
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.quiz.target?.name ?? "N/A",
                      style: const TextStyle(
                        fontWeight: FontWeight
                            .w700, // Sử dụng fontWeight tương đương cấu trúc nút Brand
                        fontSize: 15,
                        color: Color(
                          0xFF1E293B,
                        ), // Tránh dùng Colors.black để không bị đì chữ
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${DateFormat('dd/MM').format(session.startTime)} • ${session.learningSessionDetails.length} câu",
                      style: const TextStyle(
                        color: Color(
                          0xFF64748B,
                        ), // Slate secondary text mượt mà
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Khối hiển thị kết quả/Tỉ lệ chính xác
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${session.accuracyRate}%",
                    style: TextStyle(
                      color: accuracyColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isPractice ? "Đã xem" : "Đúng",
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tinh chỉnh lại mã màu trạng thái để tiệp với các Palette màu hệ thống (Brand/Slate/Danger)
  Color _getAccuracyColor(int acc) {
    if (acc >= 80)
      return const Color(0xFF22C55E); // Green chính xác cao (chuẩn hệ thống)
    if (acc >= 50) return const Color(0xFFF59E0B); // Orange trung bình
    return const Color(
      0xFFEF4444,
    ); // Danger đỏ rực rỡ tương đương ButtonVariant.danger
  }
}
