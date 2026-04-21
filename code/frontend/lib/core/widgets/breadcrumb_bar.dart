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

    // Trong hàm build của BreadcrumbBar
    final List<Map<String, String>> breadcrumbs = [];
    String accumulatedPath = "";

    for (int i = 0; i < rawSegments.length; i++) {
      String segment = rawSegments[i];

      // 1. LUÔN CẬP NHẬT PATH THẬT (Bất kể có hiển thị breadcrumb hay không)
      accumulatedPath += "/$segment";

      // 2. Logic kiểm tra xem có nên bỏ qua (gộp) segment này không
      bool isNextId =
          (i + 1 < rawSegments.length &&
          int.tryParse(rawSegments[i + 1]) != null);
      bool isCollection = ['session', 'subject', 'quiz'].contains(segment);

      if (isCollection && isNextId) {
        // Chỉ cập nhật path, KHÔNG add vào danh sách hiển thị
        continue;
      }

      // 3. Xử lý hiển thị
      bool isId = int.tryParse(segment) != null;
      String title = "";

      if (isId && i > 0) {
        String parentSegment = rawSegments[i - 1];
        title = _mapIdToTitle(parentSegment, segment);
      } else if (segment == 'result' &&
          i > 0 &&
          rawSegments[i - 1] == 'learning') {
        title = 'Lịch sử';
      } else {
        title = _mapPathToTitle(segment);
      }

      breadcrumbs.add({
        'title': title,
        'path': accumulatedPath, // Bây giờ path đã bao gồm đầy đủ các segment
      });
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
