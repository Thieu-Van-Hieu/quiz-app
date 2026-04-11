import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/breadcrumb_bar.dart';
import 'package:frontend/core/widgets/sidebar_button.dart';
import 'package:frontend/core/widgets/sidebar_header.dart';
import 'package:frontend/features/dashboard/constants/dashboard_colors.dart';
import 'package:frontend/routes/app_route_config.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends HookWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final menuItems = AppRouteConfig.mainMenuItems;
    final isCollapsed = useState(false);

    // Lấy path hiện tại để check active
    final String location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: Row(
        children: [
          // --- VÙNG SIDEBAR ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isCollapsed.value ? 70 : 260,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: DashboardColors.sidebarHeader),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SidebarHeader(isCollapsed: isCollapsed.value),

                // Nút thu gọn/mở rộng
                IconButton(
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: () => isCollapsed.value = !isCollapsed.value,
                  icon: Icon(isCollapsed.value ? Icons.menu_open : Icons.menu),
                ),

                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];

                      final bool isAction = item.path == null;

                      // LOGIC ACTIVE: Nếu route hiện tại bắt đầu bằng path của item
                      // Ví dụ: /library/subject/1 vẫn tính là bắt đầu bằng /library
                      final bool isSelected =
                          !isAction && location.startsWith(item.path!);

                      return SidebarButton(
                        title: isCollapsed.value ? "" : item.title,
                        icon: item.icon,
                        isSelected: isSelected,
                        onTap: () {
                          if (item.onTap != null) {
                            // Nếu có onTap (như nút Thoát), thực thi ngay
                            item.onTap!(context);
                          } else {
                            // LỌC INDEX THỰC TẾ:
                            // Chỉ đếm những item có path (các branch thực sự)
                            final actualBranchIndex = menuItems
                                .take(index)
                                .where((m) => m.path != null)
                                .length;

                            navigationShell.goBranch(
                              actualBranchIndex,
                              initialLocation: false,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                // --- ĐÂY LÀ CHỖ THÊM BIỆT DANH ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isCollapsed.value)
                        Text(
                          "Made with ❤️ by",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        "Mr.NoBody",
                        style: TextStyle(
                          color: DashboardColors.sidebarHeader.withValues(
                            alpha: 0.8,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: isCollapsed.value ? 8 : 14,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- VÙNG NỘI DUNG ---
          Expanded(
            child: Container(
              color: DashboardColors.backgroundContent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbBar(),
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
