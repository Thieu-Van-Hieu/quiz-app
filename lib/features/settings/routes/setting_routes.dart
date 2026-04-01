// features/settings/routes/settings_routes.dart
import 'package:flutter/material.dart';
import 'package:frontend/routes/types.dart';

class SettingsRoutes {
  static const String root = '/settings';

  static final AppRouteItem config = AppRouteItem(
    title: 'Cài đặt',
    path: root,
    icon: Icons.settings_suggest_rounded,
    builder: (context) => const Center(child: Text("Cấu hình hệ thống")),
  );
}
