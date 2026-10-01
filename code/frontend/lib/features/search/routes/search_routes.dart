import 'package:flutter/material.dart';
import 'package:frontend/features/search/pages/master_search_page.dart';
import 'package:frontend/routes/types.dart';

class SearchRoutes {
  static const String root = '/search';

  static final AppRouteItem config = AppRouteItem(
    title: 'Tìm kiếm',
    path: root,
    icon: Icons.manage_search_rounded,
    builder: (context) => const MasterSearchPage(),
  );
}
