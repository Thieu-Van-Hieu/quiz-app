// features/library/routes/library_routes.dart
import 'package:flutter/material.dart';
import 'package:frontend/features/library/pages/library_page.dart';
import 'package:frontend/routes/types.dart';

// features/library/routes/library_routes.dart
class LibraryRoutes {
  static const String root = '/library';
  static const String courses =
      'courses/:id'; // Thay môn học bằng course/workspace

  static final AppRouteItem config = AppRouteItem(
    title: 'Thư viện',
    path: root,
    icon: Icons.folder_copy_rounded,
    builder: (context) => const LibraryPage(),
    subRoutes: [
      AppRouteItem(
        title: 'Chi tiết Học phần',
        path: courses,
        builder: (context) => const Center(child: Text("Danh sách Bộ đề")),
      ),
    ],
  );
}
