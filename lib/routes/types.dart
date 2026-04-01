import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteItem {
  final String title;
  final String? path;
  final String? fullPath;
  final IconData? icon;
  final Widget Function(BuildContext context)? builder;
  final List<AppRouteItem>? subRoutes;
  final void Function(BuildContext context)? onTap;

  // --- THÊM FIELD REDIRECT TƯƠNG TỰ GO_ROUTER ---
  final String? Function(BuildContext context, GoRouterState state)? redirect;

  const AppRouteItem({
    required this.title,
    this.icon,
    this.path,
    this.fullPath,
    this.builder,
    this.subRoutes,
    this.onTap,
    this.redirect, // Gán vào đây
  });

  GoRoute? toGoRoute() {
    // Lưu ý: GoRoute có thể không cần builder nếu nó chỉ có redirect
    if (path == null) {
      return null;
    }

    return GoRoute(
      path: path!,
      // Map hàm redirect từ AppRouteItem sang GoRoute
      redirect: redirect,
      // Nếu có redirect mà không có builder thì GoRouter vẫn chạy tốt
      builder: builder != null ? (context, state) => builder!(context) : null,
      routes:
          subRoutes
              ?.map((sub) => sub.toGoRoute())
              .whereType<GoRoute>()
              .toList() ??
          [],
    );
  }
}
