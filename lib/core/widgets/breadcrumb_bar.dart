import 'package:flutter/material.dart';
import 'package:frontend/routes/app_route_config.dart';
import 'package:go_router/go_router.dart';

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final location = routerState.uri.path;

    // Tách các phần của URL, bỏ khoảng trống
    final rawSegments = location.split('/').where((s) => s.isNotEmpty).toList();

    // 1. Logic xử lý gộp Segment (Gộp "subject" + "id", "quiz" + "id")
    final List<Map<String, String>> breadcrumbs = [];
    String accumulatedPath = "";
    int i = 0;

    while (i < rawSegments.length) {
      String segment = rawSegments[i];
      accumulatedPath += "/$segment";

      // Nếu gặp 'subject' hoặc 'quiz' và phía sau có ID (là số)
      if ((segment == 'subject' || segment == 'quiz') &&
          (i + 1 < rawSegments.length)) {
        String nextSegment = rawSegments[i + 1];
        if (int.tryParse(nextSegment) != null) {
          // GỘP CHÚNG LẠI: Ví dụ: /library/subject/1 -> Title: "Môn học"
          breadcrumbs.add({
            'title': segment == 'subject' ? "Môn học" : "Bộ đề",
            'path': "$accumulatedPath/$nextSegment",
          });
          accumulatedPath += "/$nextSegment"; // Cập nhật path bao gồm cả ID
          i += 2; // Nhảy qua cả 2 segment
          continue;
        }
      }

      // Xử lý các segment thông thường (dashboard, library, etc.)
      breadcrumbs.add({
        'title': _mapPathToTitle(segment),
        'path': accumulatedPath,
      });
      i++;
    }

    // 2. Lọc bỏ Dashboard nếu đang ở trang con (để đỡ rác)
    if (breadcrumbs.isNotEmpty && breadcrumbs.first['path'] == '/dashboard') {
      if (breadcrumbs.length > 1) {
        breadcrumbs.removeAt(0);
      } else {
        // Nếu chỉ có mỗi Dashboard thì đổi title thành Tổng quan
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

  String _mapPathToTitle(String segment) {
    // 1. Ưu tiên tìm trong AppRouteConfig (cho Dashboard, Library, etc.)
    final menuItem = AppRouteConfig.mainMenuItems.where((item) {
      return item.path != null &&
          (item.path == '/$segment' || item.path!.endsWith('/$segment'));
    }).firstOrNull;

    if (menuItem != null) return menuItem.title;

    // 2. Map các từ khóa tĩnh
    final subPathMap = {
      'subject': 'Môn học',
      'quiz': 'Bộ đề',
      'result': 'Kết quả',
      'library': 'Thư viện',
    };

    if (subPathMap.containsKey(segment)) return subPathMap[segment]!;

    // 3. Xử lý mặc định (Viết hoa chữ cái đầu)
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
