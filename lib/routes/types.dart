import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteItem {
  final String title;
  final String? path; // Action thì không cần path
  final String? fullPath;
  final IconData? icon;
  final Widget Function(BuildContext context)?
  builder; // Action thì không cần builder
  final List<AppRouteItem>? subRoutes;
  final void Function(BuildContext context)?
  onTap; // <--- Thêm cái này để xử lý Exit

  const AppRouteItem({
    required this.title,
    this.icon,
    this.path,
    this.fullPath,
    this.builder,
    this.subRoutes,
    this.onTap, // Thêm hành động vào đây
  });

  // Hàm này vẫn giữ để build Router, nhưng lọc bỏ những cái không có builder
  GoRoute? toGoRoute() {
    if (path == null || builder == null) {
      return null; // Nếu là Action thì trả về null
    }
    return GoRoute(
      path: path!,
      builder: (context, state) => builder!(context),
      routes:
          subRoutes
              ?.map((sub) => sub.toGoRoute())
              .whereType<GoRoute>()
              .toList() ??
          [],
    );
  }
}
