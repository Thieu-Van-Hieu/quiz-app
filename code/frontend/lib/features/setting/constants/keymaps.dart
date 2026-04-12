import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/setting/enums/physical_key.dart';

class KeyMaps {
  static const Map<PhysicalKey, LogicalKeyboardKey> physicalToLogical = {
    PhysicalKey.enter: LogicalKeyboardKey.enter,
    PhysicalKey.space: LogicalKeyboardKey.space,
    PhysicalKey.arrowRight: LogicalKeyboardKey.arrowRight,
    PhysicalKey.arrowLeft: LogicalKeyboardKey.arrowLeft,
  };

  static const Map<int, PhysicalKey> mouseButtonsMap = {
    kPrimaryMouseButton: PhysicalKey.mouseLeft, // Chuột trái
    kSecondaryMouseButton: PhysicalKey.mouseRight, // Chuột phải
    kMiddleMouseButton: PhysicalKey.mouseMiddle, // Chuột giữa
    kBackMouseButton: PhysicalKey.mouseBack, // Nút quay lại (nếu có)
    kForwardMouseButton: PhysicalKey.mouseForward, // Nút tiến (nếu có)
  };

  static final Map<LogicalKeyboardKey, PhysicalKey> logicalToPhysical =
      physicalToLogical.map((k, v) => MapEntry(v, k));
}
