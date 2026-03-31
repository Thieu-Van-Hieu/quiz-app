import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';
import 'package:frontend/routes/app_route_config.dart'; // Dùng config mới
import 'package:frontend/features/dashboard/widgets/sidebar_button.dart';
import 'package:frontend/features/dashboard/widgets/sidebar_header.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends HookWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final menuItems = AppRouteConfig.mainMenuItems;

    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR AREA
          Container(
            width: 250, // Tăng nhẹ width để chữ tiếng Việt không bị gò bó
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.sidebarBorder)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SidebarHeader(),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];

                      // Một mục được coi là "Selected" nếu nó không phải Action
                      // và index của nó khớp với branch hiện tại của Router
                      final bool isAction = item.path == null;
                      final bool isSelected =
                          !isAction && navigationShell.currentIndex == index;

                      return SidebarButton(
                        title: item.title,
                        icon: item.icon!,
                        isSelected: isSelected,
                        onTap: () {
                          if (item.onTap != null) {
                            // Nếu có hàm onTap (nút Thoát) -> Thực thi ngay
                            item.onTap!(context);
                          } else if (item.path != null) {
                            // Nếu là Route -> Chuyển branch
                            navigationShell.goBranch(
                              index,
                              initialLocation:
                                  index == navigationShell.currentIndex,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // CONTENT AREA
          Expanded(
            child: Container(
              color: AppColors.backgroundContent,
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}
