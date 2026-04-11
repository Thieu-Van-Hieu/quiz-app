// features/library/routes/library_routes.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/library/pages/question_page.dart'; // Import trang Quiz mới
import 'package:frontend/features/library/pages/quiz_page.dart';
import 'package:frontend/features/library/pages/subject_page.dart';
import 'package:frontend/routes/types.dart';
import 'package:go_router/go_router.dart';

class LibraryRoutes {
  static const String root = '/library';
  static const String subject = 'subject';
  static const String quiz = 'quiz';

  // Helper để lấy path nhanh
  static String getSubjectDetailPath(int id) => '$root/$subject/$id';
  static String getQuizDetailPath(int subjectId, int quizId) =>
      '$root/$subject/$subjectId/quiz/$quizId';

  static final AppRouteItem config = AppRouteItem(
    title: 'Thư viện',
    path: root,
    icon: Icons.folder_copy_rounded,
    builder: (context) => SubjectPage(),
    subRoutes: [
      AppRouteItem(
        title: 'Chi tiết Học phần',
        path: '$subject/:subjectId',
        builder: (context) {
          final state = GoRouterState.of(context);
          final subjectId =
              int.tryParse(state.pathParameters['subjectId'] ?? '0') ?? 0;
          return QuizPage(subjectId: subjectId);
        },
        // --- THÊM SUB-ROUTE CHO QUIZ DETAIL TẠI ĐÂY ---
        subRoutes: [
          AppRouteItem(
            title: 'Chi tiết Bộ đề',
            path: '$quiz/:quizId',
            builder: (context) {
              final state = GoRouterState.of(context);
              // Lấy subjectId từ cha (:id) và quizId từ chính nó (:quizId)
              final subjectId =
                  int.tryParse(state.pathParameters['subjectId'] ?? '0') ?? 0;
              final quizId =
                  int.tryParse(state.pathParameters['quizId'] ?? '0') ?? 0;

              return QuestionPage(subjectId: subjectId, quizId: quizId);
            },
          ),
        ],
      ),
    ],
  );
}
