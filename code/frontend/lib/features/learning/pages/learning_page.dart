import 'package:flutter/material.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/pages/exam_page.dart';
import 'package:frontend/features/learning/pages/practice_page.dart';
import 'package:frontend/features/learning/pages/study_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LearningPage extends HookConsumerWidget {
  final int sessionId;

  const LearningPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(watchLearningSessionProvider(sessionId));

    return sessionAsync.when(
      // 1. Màn hình Loading đơn giản
      loading: () => const Material(
        color: Color(0xFFD4D0C8), // Màu xám đặc trưng Win98
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Loading System...",
                style: TextStyle(
                  fontFamily: 'MS Sans Serif',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),

      // 2. Màn hình Error
      error: (err, stack) => Material(
        color: const Color(0xFFD4D0C8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
            child: Text("Fatal Error: $err"),
          ),
        ),
      ),

      data: (session) {
        if (session == null) {
          return const Material(
            child: Center(child: Text("404 - Session Not Found")),
          );
        }

        // --- PHÂN LUỒNG VIEW ---

        // 1. Đã xong -> Review
        if (session.isCompleted) {
          // Bạn sẽ tạo file này sau
          return Center(
            child: Text("Trang kết quả cho session: ${session.id}"),
          );
        }

        // 2. Đang học -> Theo Mode
        // Ở đây mình giả sử bạn đã tách các View ra file riêng
        switch (LearningMode.fromString(session.learningMode)) {
          case LearningMode.exam:
            return ExamPage(sessionId: sessionId);
          case LearningMode.practice:
            return PracticePage(sessionId: sessionId);
          case LearningMode.study:
            return StudyPage(sessionId: sessionId);
          default:
            // return LearningPracticeView(session: session);
            return Center(
              child: Text("Giao diện ÔN TẬP của session: ${session.id}"),
            );
        }
      },
    );
  }
}
