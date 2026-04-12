import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/widgets/eos/header.dart';
import 'package:frontend/features/setting/notifiers/app_config_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Record trả về: (Cái Widget Header, giá trị FontSize, giá trị FontFamily)
(Widget, double, String) useEosHeader({
  required WidgetRef ref,
  required Map<String, String> info,
  required Widget clockWidget,
}) {
  // 1. Lấy config từ Provider
  final configAsync = ref.watch(watchAppConfigProvider);

  // 2. Lấy giá trị từ config hoặc fallback
  final defaultFontSize = configAsync.maybeWhen(
    data: (cfg) => cfg?.fontSize ?? 14.0,
    orElse: () => 14.0,
  );

  final defaultFontFamily = configAsync.maybeWhen(
    data: (cfg) => cfg?.fontFamily ?? "Microsoft Sans Serif",
    orElse: () => "Microsoft Sans Serif",
  );

  // 3. Quản lý State nội bộ của Header
  final fontSize = useState(defaultFontSize);
  final fontFamily = useState(defaultFontFamily);

  // 4. Khởi tạo Widget Header và gắn Notifier vào
  final headerWidget = EosHeader(
    info: info,
    clockWidget: clockWidget,
    fontSizeNotifier: fontSize, // Truyền notifier vào để Header tự lo
    fontFamilyNotifier: fontFamily,
  );

  // 5. Trả về Record để Page cha "phá cấu trúc"
  return (headerWidget, fontSize.value, fontFamily.value);
}
