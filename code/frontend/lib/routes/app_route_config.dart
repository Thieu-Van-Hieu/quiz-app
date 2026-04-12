import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/dashboard/routes/dashboard_routes.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/setting/routes/setting_routes.dart';
import 'package:frontend/routes/types.dart';

// Hàm xử lý hiện Dialog thoát
void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Xác nhận thoát"),
      content: const Text("Bạn có chắc chắn muốn đóng ứng dụng?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Hủy"),
        ),
        TextButton(
          onPressed: () {
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              exit(0); // Lệnh thoát mạnh mẽ cho Desktop
            } else {
              SystemNavigator.pop(); // Dành cho Mobile
            }
          }, // Thoát app sạch sẽ
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Thoát", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

class AppRouteConfig {
  static final List<AppRouteItem> mainMenuItems = [
    DashboardRoutes.config,
    LibraryRoutes.config,
    LearningRoutes.config,
    SettingRoutes.config,
    AppRouteItem(
      title: 'Thoát',
      icon: Icons.logout_rounded,
      onTap: (context) {
        // Gọi hàm xử lý thoát từ utils.dart hoặc hiện Dialog tại đây
        _showExitDialog(context);
      },
    ),
  ];
}
