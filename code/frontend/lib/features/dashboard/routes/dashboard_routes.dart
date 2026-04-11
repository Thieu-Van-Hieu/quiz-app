import 'package:flutter/material.dart';
import 'package:frontend/routes/types.dart';

// features/dashboard/routes/dashboard_routes.dart
class DashboardRoutes {
  static const String root = '/dashboard'; // URL tiếng Anh

  static final AppRouteItem config = AppRouteItem(
    title: 'Tổng quan', // Hiển thị tiếng Việt
    path: root,
    icon: Icons.dashboard_rounded,
    builder: (context) => const Center(child: Text("Màn hình Tổng quan")),
  );
}
