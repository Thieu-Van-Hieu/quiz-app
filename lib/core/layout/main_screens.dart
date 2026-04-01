import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/breadcrumb_bar.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';
import 'package:frontend/routes/app_route_config.dart'; // Dùng config mới
import 'package:frontend/core/widgets/sidebar_button.dart';
import 'package:frontend/core/widgets/sidebar_header.dart';
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
          // --- VÙNG SIDEBAR (Cố định bên trái) ---
          Container(
            width: 260, // Chiều rộng Sidebar thoải mái cho tiếng Việt
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: DashboardColors.sidebarHeader),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SidebarHeader(),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];

                      // Logic xác định mục đang được chọn
                      final bool isAction = item.path == null;
                      final bool isSelected =
                          !isAction && navigationShell.currentIndex == index;

                      return SidebarButton(
                        title: item.title,
                        icon: item.icon!,
                        isSelected: isSelected,
                        onTap: () {
                          if (item.onTap != null) {
                            // Nếu là Action (ví dụ: nút Thoát)
                            item.onTap!(context);
                          } else if (item.path != null) {
                            // Nếu là Route (Chuyển trang)
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

          // --- VÙNG NỘI DUNG CHÍNH (Bên phải) ---
          Expanded(
            child: Container(
              color: DashboardColors.backgroundContent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thanh Breadcrumb nằm cố định ở trên đầu nội dung
                  const BreadcrumbBar(),

                  // Phần nội dung thay đổi linh hoạt theo Route (Library, Study, Settings...)
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
