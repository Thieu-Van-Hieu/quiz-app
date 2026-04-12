import 'package:flutter/material.dart';
import 'package:frontend/features/setting/pages/setting_page.dart';
import 'package:frontend/routes/types.dart';

class SettingRoutes {
  static const String root = '/setting'; // URL tiếng Anh

  static final AppRouteItem config = AppRouteItem(
    title: 'Cài đặt', // Hiển thị tiếng Việt
    path: root,
    icon: Icons.settings,
    builder: (context) => SettingPage(),
  );
}
