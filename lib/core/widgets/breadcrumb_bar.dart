import 'package:flutter/material.dart';
import 'package:frontend/routes/app_route_config.dart';
import 'package:go_router/go_router.dart';

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final location = routerState.uri.path;

    // Sử dụng logic lọc segment đã viết
    final displaySegments = _getFilteredSegments(location);

    return Container(
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 8),
      child: Row(
        children: [
          // Nếu ở trang chủ (Dashboard) và list rỗng, có thể hiện "Tổng quan"
          // hoặc ẩn luôn thanh này tùy phen. Ở đây mình ẩn luôn cho sạch.
          if (displaySegments.isEmpty && location.contains('dashboard'))
            _buildItem(context, "Tổng quan", "/dashboard", true),

          for (int i = 0; i < displaySegments.length; i++) ...[
            if (i > 0)
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Colors.grey,
              ),

            _buildItem(
              context,
              _mapPathToTitle(displaySegments[i]),
              // Build lại path chuẩn để ấn quay lại được
              _buildPathForSegment(displaySegments, i),
              i == displaySegments.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  // Lấy list segment đã lọc bỏ dashboard
  List<String> _getFilteredSegments(String location) {
    final segments = location.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isNotEmpty &&
        (segments.first == 'dashboard' || segments.first == 'overview')) {
      segments.removeAt(0);
    }
    return segments;
  }

  // Helper để tạo path chuẩn khi click vào breadcrumb
  String _buildPathForSegment(List<String> segments, int index) {
    // Vì mình đã lọc bỏ dashboard, nên khi build path cần check xem gốc là gì
    // Ở đây mình giả định các route này thuộc / (root) hoặc /library
    return "/${segments.sublist(0, index + 1).join('/')}";
  }

  String _mapPathToTitle(String segment) {
    final menuItem = AppRouteConfig.mainMenuItems.where((item) {
      return item.path != null &&
          (item.path == '/$segment' || item.path!.endsWith(segment));
    }).firstOrNull;

    if (menuItem != null) return menuItem.title;

    final subPathMap = {
      'subject': 'Môn học',
      'quiz': 'Bộ đề',
      'result': 'Kết quả',
    };

    if (subPathMap.containsKey(segment)) return subPathMap[segment]!;
    if (int.tryParse(segment) != null) return 'Chi tiết';

    return segment.isEmpty
        ? ""
        : segment[0].toUpperCase() + segment.substring(1);
  }

  Widget _buildItem(
    BuildContext context,
    String title,
    String path,
    bool isLast,
  ) {
    return InkWell(
      onTap: isLast ? null : () => context.go(path),
      mouseCursor: isLast ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: TextStyle(
            color: isLast ? Colors.black87 : Colors.grey[600],
            fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
