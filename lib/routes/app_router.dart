import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/layout/main_screens.dart';
import 'package:frontend/features/dashboard/routes/dashboard_routes.dart';
import 'package:frontend/routes/app_route_config.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: DashboardRoutes.root, // /dashboard
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) =>
          DashboardRoutes.root, // Đá sang /dashboard ngay
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScreen(navigationShell: navigationShell),
      branches: AppRouteConfig.mainMenuItems
          .map((item) => item.toGoRoute()) // Chuyển sang GoRoute
          .whereType<GoRoute>() // Lọc bỏ các Action (như nút Thoát)
          .map((route) {
            return StatefulShellBranch(routes: [route]);
          })
          .toList(),
    ),
  ],
);
