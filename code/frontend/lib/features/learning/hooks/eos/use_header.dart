import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/widgets/eos/header.dart';

// Record trả về: (Cái Widget Header, giá trị FontSize, giá trị FontFamily)
(Widget, double, String) useEosHeader({
  required Map<String, String> info,
  required Widget clockWidget,
  double initialSize = 14.0,
  String initialFont = "Microsoft Sans Serif",
}) {
  // 1. Quản lý State nội bộ của Header
  final fontSize = useState(initialSize);
  final fontFamily = useState(initialFont);

  // 2. Khởi tạo Widget Header và gắn Notifier vào
  final headerWidget = EosHeader(
    info: info,
    clockWidget: clockWidget,
    fontSizeNotifier: fontSize, // Truyền notifier vào để Header tự lo
    fontFamilyNotifier: fontFamily,
  );

  // 3. Trả về Record để Page cha "phá cấu trúc"
  return (headerWidget, fontSize.value, fontFamily.value);
}
