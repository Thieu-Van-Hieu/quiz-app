import 'package:flutter/material.dart';
import 'package:frontend/features/learning/pages/learning_page.dart';
import 'package:frontend/features/learning/pages/learning_result_page.dart';
import 'package:frontend/routes/types.dart';
import 'package:go_router/go_router.dart';

class LearningRoutes {
  static const String root = '/learning';
  static const String result = 'result';
  static const String session = 'session';
  static const String sessionDetail = ':sessionId';

  /// --- HÀM LẤY PATH ---
  static String get resultPath => '$root/$result';

  static String sessionPath(dynamic id) => '$root/$session/$id';

  static final AppRouteItem config = AppRouteItem(
    title: 'Học tập',
    path: root,
    icon: Icons.menu_book_rounded,

    // 1. THIẾT LẬP MẶC ĐỊNH:
    // Khi người dùng vào /learning, tự động điều hướng sang /learning/result
    redirect: (context, state) {
      if (state.uri.path == root) {
        return resultPath;
      }
      return null;
    },

    // Builder của root lúc này có thể để trang Lịch sử hoặc một Loading
    // vì redirect sẽ đẩy người dùng đi trước khi kịp render.
    builder: (context) => const LearningResultPage(),

    subRoutes: [
      // /learning/result
      AppRouteItem(
        title: 'Lịch sử',
        path: result,
        builder: (context) => const LearningResultPage(),
      ),

      // /learning/session
      AppRouteItem(
        title: 'Phiên học',
        path: session,
        // Nếu lỡ vào /learning/session mà không có ID, cũng cho về trang kết quả
        redirect: (context, state) {
          if (state.uri.path == '$root/$session') return resultPath;
          return null;
        },
        builder: (context) => const SizedBox.shrink(),
        subRoutes: [
          // /learning/session/:sessionId
          AppRouteItem(
            title: 'Chi tiết phiên học',
            path: sessionDetail,
            builder: (context) {
              final state = GoRouterState.of(context);
              final id =
                  int.tryParse(state.pathParameters['sessionId'] ?? '') ?? 0;
              return LearningPage(sessionId: id);
            },
          ),
        ],
      ),
    ],
  );
}
