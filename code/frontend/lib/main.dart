import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/services/database_cleanup_service.dart';
import 'package:frontend/core/services/device_info_service.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/routes/app_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

const String appcastURL =
    'https://raw.githubusercontent.com/Thieu-Van-Hieu/quiz-app/refs/heads/main/deploy/appcast.xml';

void main() async {
  // 1. Đảm bảo Flutter đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo các service
  await AppPathService().init();
  await ObjectBoxService.create();
  await DatabaseCleanupService.runFullCleanup();
  await DeviceInfoService().init();

  // 3. Khởi chạy Auto Updater cho Windows
  if (!kDebugMode && Platform.isWindows) {
    await autoUpdater.setFeedURL(appcastURL);
    await autoUpdater.setScheduledCheckInterval(7200); // Check mỗi 2 tiếng
    await autoUpdater.checkForUpdates(inBackground: true);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is AssertionError &&
          details.exception.toString().contains('mouse_tracker')) {
        return; // "Câm nín" cái lỗi chuột phiền phức kia
      }
      FlutterError.presentError(details);
    };

    return MaterialApp.router(
      title: AppStrings.appName,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      // Sửa ở đây: Bọc UpgradeAlert bên trong Navigator Context
      builder: (context, child) {
        if (!kDebugMode && Platform.isLinux) {
          return UpgradeAlert(
            upgrader: Upgrader(
              storeController: UpgraderStoreController(
                onLinux: () => UpgraderAppcastStore(appcastURL: appcastURL),
              ),
              languageCode: 'vi',
            ),
            // Bọc bằng Builder để lấy BuildContext bên dưới Navigator
            child: Builder(
              builder: (innerContext) => child ?? const SizedBox.shrink(),
            ),
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
