// lib/core/services/ocr/ocr_controller.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:path/path.dart' as p;

import 'ocr_providers.dart';

final ocrControllerProvider = Provider((ref) => OcrController(ref));

class OcrController {
  final Ref _ref;
  bool _isBusy = false;

  OcrController(this._ref);

  /// Hàm thay thế hoàn toàn cho OcrUtils.scan()
  Future<String> scanScreen() async {
    if (_isBusy) return "BUSY";

    // Lấy tempPath từ AppPathService đã được config chuẩn theo OS
    final tempDir = AppPathService().tempPath;
    final String jobId = DateTime.now().millisecondsSinceEpoch.toString();
    final imagePath = p.join(tempDir, 'ocr_clip_$jobId.png');
    final outputBase = p.join(tempDir, 'ocr_out_$jobId');

    try {
      _isBusy = true;

      // 1. Tự động lấy WindowsCaptureService hoặc LinuxCaptureService tùy theo OS
      final captureService = _ref.read(captureServiceProvider);
      final bool captureSuccess = await captureService.captureArea(imagePath);

      if (!captureSuccess) return "USER_CANCELLED";

      // 2. Chạy Tesseract OCR
      final tesseractService = _ref.read(tesseractServiceProvider);
      final String result = await tesseractService.run(imagePath, outputBase);

      return result;
    } catch (e) {
      return "Lỗi hệ thống: $e";
    } finally {
      _cleanupFiles([imagePath, '$outputBase.txt']);
      _isBusy = false;
    }
  }

  void _cleanupFiles(List<String> paths) {
    for (var path in paths) {
      try {
        if (File(path).existsSync()) File(path).deleteSync();
      } catch (_) {}
    }
  }
}
