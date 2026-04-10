import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:screen_capturer/screen_capturer.dart';

class OcrUtils {
  static final OcrUtils _instance = OcrUtils._internal();

  factory OcrUtils() => _instance;

  OcrUtils._internal();

  static const String _ocrLanguages = 'vie+eng';

  String? _cachedTessDataPath;
  String? _resolvedTesseractPath;
  bool _isBusy = false;

  static Future<void> init() => _instance.initOcr();

  static Future<String> scan() => _instance.processOcr();

  Future<void> initOcr() async {
    if (_cachedTessDataPath != null && _resolvedTesseractPath != null) return;

    // 1. Chuẩn bị TessData (Copy từ assets ra folder Local App Data để có quyền ghi)
    _cachedTessDataPath = await _prepareTessData();

    // 2. Xác định đường dẫn Tesseract Engine
    if (Platform.isWindows) {
      // Lấy thư mục chứa file .exe của chính app Flutter
      final String appDir = p.dirname(Platform.resolvedExecutable);

      // Đường dẫn khi ĐÃ ĐÓNG GÓI (nằm trong folder tesseract_engine)
      final String productionPath = p.join(
        appDir,
        'tesseract_engine',
        'tesseract.exe',
      );

      // Đường dẫn khi ĐANG DEBUG (trỏ thẳng tới Scoop của bạn để chạy cho nhanh)
      const String debugPath =
          r'D:\Windows\PackageManager\Scoop\shims\tesseract.exe';

      if (await File(productionPath).exists()) {
        _resolvedTesseractPath = productionPath;
      } else {
        _resolvedTesseractPath = debugPath;
      }
    }
  }

  Future<String> processOcr() async {
    if (_isBusy) return "BUSY";

    try {
      _isBusy = true;
      if (_cachedTessDataPath == null || _resolvedTesseractPath == null) {
        await initOcr();
      }

      // Kiểm tra file engine lần cuối
      if (!await File(_resolvedTesseractPath!).exists()) {
        return "Lỗi: Không tìm thấy Tesseract Engine tại $_resolvedTesseractPath";
      }

      final tempDir = await getTemporaryDirectory();
      final String jobId = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = p.join(tempDir.path, 'ocr_in_$jobId.png');
      final outputBase = p.join(tempDir.path, 'ocr_out_$jobId');

      // Dọn dẹp helper cũ của screen_capturer
      if (Platform.isWindows) {
        await Process.run('taskkill', [
          '/F',
          '/IM',
          'screen_capturer_helper.exe',
          '/T',
        ]).catchError((_) => ProcessResult(0, 1, '', ''));
      }

      await Future.delayed(const Duration(milliseconds: 200));

      // Chụp màn hình vùng chọn
      CapturedData? capturedData = await screenCapturer.capture(
        mode: CaptureMode.region,
        imagePath: imagePath,
      );

      if (capturedData == null) return "USER_CANCELLED";

      // Đợi file ảnh ghi xong hoàn toàn
      await Future.delayed(const Duration(milliseconds: 400));
      if (!File(imagePath).existsSync()) return "Lỗi: Không lưu được ảnh chụp.";

      // 3. Thực thi Tesseract
      final result = await Process.run(_resolvedTesseractPath!, [
        '--tessdata-dir',
        _cachedTessDataPath!,
        imagePath,
        outputBase,
        '-l',
        _ocrLanguages,
      ]);

      if (result.exitCode == 0) {
        final resFile = File('$outputBase.txt');
        if (await resFile.exists()) {
          String text = await resFile.readAsString();
          _cleanupFiles([imagePath, '$outputBase.txt']);
          return text.trim().isEmpty
              ? "Không tìm thấy nội dung chữ."
              : text.trim();
        }
      }
      return "Lỗi Tesseract: ${result.stderr}";
    } catch (e) {
      return "Lỗi hệ thống: $e";
    } finally {
      _isBusy = false;
    }
  }

  Future<String> _prepareTessData() async {
    final String tessDataDir = AppPathService().tessDataPath;

    for (var lang in ['eng', 'vie']) {
      final file = File(p.join(tessDataDir, '$lang.traineddata'));
      // Chỉ copy nếu file chưa tồn tại để tiết kiệm tài nguyên
      if (!await file.exists()) {
        try {
          final data = await rootBundle.load(
            'assets/tessdata/$lang.traineddata',
          );
          await file.writeAsBytes(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          );
        } catch (e) {
          debugPrint("Lỗi copy traineddata: $e");
        }
      }
    }
    return tessDataDir;
  }

  void _cleanupFiles(List<String> paths) {
    for (var path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        try {
          file.deleteSync();
        } catch (_) {}
      }
    }
  }
}
