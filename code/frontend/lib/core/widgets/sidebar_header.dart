import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';

class SidebarHeader extends StatelessWidget {
  final bool isCollapsed;
  const SidebarHeader({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80, // Cố định chiều cao
      padding: const EdgeInsets.all(8),
      color: DashboardColors.sidebarHeader,
      child: isCollapsed
          ? const Icon(Icons.bolt, size: 32) // Hiện logo ngắn gọn khi thu nhỏ
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(AppStrings.appVersion, style: TextStyle(fontSize: 12)),
              ],
            ),
    );
  }
}
