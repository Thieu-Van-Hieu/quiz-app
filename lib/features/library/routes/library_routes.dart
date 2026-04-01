// features/library/routes/library_routes.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/library/pages/subject_page.dart';
import 'package:frontend/features/library/pages/subject_detail_page.dart'; // Import trang mới
import 'package:frontend/routes/types.dart';
import 'package:go_router/go_router.dart'; // Cần để dùng GoRouterState

class LibraryRoutes {
  static const String root = '/library';
  static const String subject = 'subject';
  static const String subjectDetail = 'subject/:id';
  static String getSubjectDetailPath(int id) {
    return '$root/$subject/$id';
  }

  static final AppRouteItem config = AppRouteItem(
    title: 'Thư viện',
    path: root,
    icon: Icons.folder_copy_rounded,
    redirect: (context, state) {
      if (state.uri.toString() == root) return '$root/$subject';
      return null;
    },
    subRoutes: [
      AppRouteItem(
        title: 'Học phần',
        path: subject,
        builder: (context) => const SubjectPage(),
        subRoutes: [
          AppRouteItem(
            title: 'Chi tiết Học phần',
            path: ':id',
            // Ép kiểu id từ String sang int để khớp với SubjectDetailPage
            builder: (context) {
              final state = GoRouterState.of(context);
              final idString = state.pathParameters['id'] ?? '0';
              final id = int.tryParse(idString) ?? 0;
              return SubjectDetailPage(subjectId: id);
            },
          ),
        ],
      ),
    ],
  );
}
