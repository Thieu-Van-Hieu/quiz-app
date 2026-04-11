import 'package:flutter/material.dart';
import 'package:frontend/routes/app_route_config.dart';
import 'package:go_router/go_router.dart';

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final location = routerState.uri.path;

    final rawSegments = location.split('/').where((s) => s.isNotEmpty).toList();

    final List<Map<String, String>> breadcrumbs = [];
    String accumulatedPath = "";

    for (int i = 0; i < rawSegments.length; i++) {
      String segment = rawSegments[i];

      // 1. Nếu segment là 'session', 'subject' hoặc 'quiz'
      // và phía sau nó CÓ một ID (số)
      if ((segment == 'session' || segment == 'subject' || segment == 'quiz') &&
          (i + 1 < rawSegments.length &&
              int.tryParse(rawSegments[i + 1]) != null)) {
        // Bỏ qua segment chữ này, để vòng lặp sau xử lý segment ID và đặt tên luôn
        // Ví dụ: bỏ qua 'session' để vòng sau xử lý '123' thành "Phiên học"
        continue;
      }

      accumulatedPath += "/$segment";
      bool isId = int.tryParse(segment) != null;

      if (isId && i > 0) {
        String parentSegment = rawSegments[i - 1];
        breadcrumbs.add({
          'title': _mapIdToTitle(parentSegment, segment),
          'path': accumulatedPath,
        });
      } else if (segment == 'result' &&
          i > 0 &&
          rawSegments[i - 1] == 'learning') {
        breadcrumbs.add({'title': 'Lịch sử', 'path': accumulatedPath});
      } else {
        breadcrumbs.add({
          'title': _mapPathToTitle(segment),
          'path': accumulatedPath,
        });
      }
    }

    // Logic lọc Dashboard (giữ nguyên)
    if (breadcrumbs.isNotEmpty && breadcrumbs.first['path'] == '/dashboard') {
      if (breadcrumbs.length > 1) {
        breadcrumbs.removeAt(0);
      } else {
        breadcrumbs[0]['title'] = "Tổng quan";
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 8),
      child: Row(
        children: [
          for (int i = 0; i < breadcrumbs.length; i++) ...[
            if (i > 0)
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Colors.grey,
              ),
            _buildItem(
              context,
              breadcrumbs[i]['title']!,
              breadcrumbs[i]['path']!,
              i == breadcrumbs.length - 1,
            ),
          ],
        ],
      ),
    );
  }

  // Map tiêu đề dựa trên ID và segment cha
  String _mapIdToTitle(String parentSegment, String id) {
    switch (parentSegment) {
      case 'session':
        return "Phiên học";
      case 'subject':
        return "Môn học";
      case 'quiz':
        return "Bộ đề";
      default:
        return "Chi tiết";
    }
  }

  String _mapPathToTitle(String segment) {
    final staticMap = {
      'learning': 'Học tập',
      'session': 'Phiên học', // Dự phòng nếu session đứng một mình
      'result': 'Kết quả', // Mặc định chung cho các chỗ khác
      'subject': 'Môn học',
      'quiz': 'Bộ đề',
      'library': 'Thư viện',
      'dashboard': 'Tổng quan',
    };

    if (staticMap.containsKey(segment)) return staticMap[segment]!;

    final menuItem = AppRouteConfig.mainMenuItems.where((item) {
      return item.path != null &&
          (item.path == '/$segment' || item.path!.endsWith('/$segment'));
    }).firstOrNull;

    if (menuItem != null) return menuItem.title;

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
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
