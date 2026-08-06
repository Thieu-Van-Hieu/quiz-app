import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/services/ocr/tesseract_service.dart';

import 'capture_service.dart';
import 'linux_capture_service.dart';
import 'windows_capture_service.dart';

/// Provider chọn CaptureService dựa trên OS
final captureServiceProvider = Provider<CaptureService>((ref) {
  if (Platform.isWindows) {
    return WindowsCaptureService();
  } else if (Platform.isLinux) {
    return LinuxCaptureService();
  }
  throw UnsupportedError('Hệ điều hành chưa được hỗ trợ');
});

final tesseractServiceProvider = Provider<TesseractService>((ref) {
  return TesseractService();
});
