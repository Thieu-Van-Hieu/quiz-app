import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/dashboard/routes/dashboard_routes.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
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
          child: const Text("Hủy"),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(), // Thoát app sạch sẽ
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
