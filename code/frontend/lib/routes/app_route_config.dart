import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/features/dashboard/routes/dashboard_routes.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/setting/routes/setting_routes.dart';
import 'package:frontend/routes/types.dart';

// Hàm xử lý hiện Dialog thoát
void _showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AppAlertDialog(
      title: "Xác nhận thoát",
      content: const Text("Bạn có chắc chắn muốn đóng ứng dụng?"),
      actions: [
        AppButton(
          label: "Thoát",
          onPressed: () {
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              exit(0);
            } else {
              SystemNavigator.pop();
            }
          },
          variant: ButtonVariant.danger,
          size: ButtonSize.small,
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
