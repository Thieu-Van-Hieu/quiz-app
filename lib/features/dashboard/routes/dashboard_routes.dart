import 'package:flutter/material.dart';
import 'package:frontend/routes/types.dart';

// features/dashboard/routes/dashboard_routes.dart
class DashboardRoutes {
  static const String root = '/dashboard';

  static final AppRouteItem config = AppRouteItem(
    title: 'Tổng quan',
    path: root,
    icon: Icons.dashboard_rounded,
    builder: (context) => const Center(child: Text("Màn hình Tổng quan")),

    // Logic Redirect để xử lý trang chủ mặc định
    redirect: (context, state) {
      // Dùng matchedLocation hoặc path sẽ chính xác hơn uri.toString() tùy version
      if (state.matchedLocation == '/') {
        return root; // Nhảy sang /dashboard
      }
      return null;
    },
  );
}
