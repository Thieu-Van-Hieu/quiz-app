import 'package:flutter/material.dart';
import 'package:frontend/features/utilities/pages/utilities_page.dart';
import 'package:frontend/routes/types.dart';

class UtilitiesRoutes {
  static const String root = '/utilities';

  static final AppRouteItem config = AppRouteItem(
    title: 'Công cụ',
    path: root,
    icon: Icons.handyman_rounded,
    builder: (context) => const UtilitiesPage(),
  );
}
