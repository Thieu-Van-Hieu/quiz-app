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
  final configAsync = ref.watch(watchAppConfigProvider);

  final config = configAsync.value;
  final defaultFontSize = config?.fontSize ?? 14.0;
  final defaultFontFamily = config?.fontFamily ?? "Microsoft Sans Serif";

  final fontSize = useState(defaultFontSize);
  final fontFamily = useState(defaultFontFamily);

  // 🎯 ĐỒNG BỘ STATE: Khi config từ DB load xong hoặc thay đổi, hãy CẬP NHẬT lại useState
  useEffect(() {
    if (config != null) {
      fontSize.value = config.fontSize;
      fontFamily.value = config.fontFamily;
    }
    return null;
  }, [config]); // Lắng nghe sự thay đổi của config object

  final headerWidget = EosHeader(
    info: info,
    clockWidget: clockWidget,
    fontSizeNotifier: fontSize,
    fontFamilyNotifier: fontFamily,
  );

  return (headerWidget, fontSize.value, fontFamily.value);
}
