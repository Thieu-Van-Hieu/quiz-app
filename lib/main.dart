import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/services/device_info_service.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/routes/app_router.dart';
import 'package:frontend/utils/ocr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  // 1. Đảm bảo Flutter đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo các service cần thiết trước khi chạy app
  await AppPathService().init();
  await ObjectBoxService.create();
  await DeviceInfoService().init();
  await OcrUtils().initOcr();

  runApp(
    // 3. Bọc ProviderScope ở đây
    const ProviderScope(child: MyApp()),
  );
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
      FlutterError.presentError(details); // Các lỗi khác vẫn hiện bình thường
    };
    return MaterialApp.router(
      title: AppStrings.appName,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    );
  }
}

// class MyApp extends HookWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ExamPage(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(useMaterial3: true),
//     );
//   }
// }
