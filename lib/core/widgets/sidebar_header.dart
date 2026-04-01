import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';
import 'package:frontend/features/dashboard/constants/dashboard_strings.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: DashboardColors.sidebarHeader,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.appName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Text(AppStrings.appVersion, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
