// features/study/routes/study_routes.dart

import 'package:flutter/material.dart';
import 'package:frontend/routes/types.dart';

class StudyRoutes {
  static const String root = '/study';
  static const String practice = 'practice';
  static const String exam = 'exam'; // Thay kiem-tra bằng exam

  static final AppRouteItem config = AppRouteItem(
    title: 'Học tập',
    path: root,
    icon: Icons.menu_book_rounded,
    builder: (context) => const Center(child: Text("Chọn chế độ học")),
    subRoutes: [
      AppRouteItem(
        title: 'Ôn tập',
        path: practice,
        builder: (context) => const Center(child: Text("Đang ôn tập")),
      ),
      AppRouteItem(
        title: 'Kiểm tra',
        path: exam,
        builder: (context) => const Center(child: Text("Đang kiểm tra")),
      ),
    ],
  );
}
