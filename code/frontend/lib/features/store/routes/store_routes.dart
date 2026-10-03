import 'package:flutter/material.dart';
import 'package:frontend/features/store/pages/quiz_store_page.dart';
import 'package:frontend/routes/types.dart';

class StoreRoutes {
  static const String root = '/store';

  static final AppRouteItem config = AppRouteItem(
    title: 'Kho đề',
    path: root,
    icon: Icons.cloud_download_rounded,
    builder: (context) => const QuizStorePage(),
  );
}
