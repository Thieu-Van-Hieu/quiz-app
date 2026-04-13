import 'dart:io';

import 'package:flutter/services.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
    _cachedTessDataPath = await _prepareTessData();
    _resolvedTesseractPath = await _findTesseractPath();
  }

  Future<String> processOcr() async {
    if (_isBusy) return "BUSY";

    try {
      _isBusy = true;
      if (_cachedTessDataPath == null || _resolvedTesseractPath == null) {
        await initOcr();
      }

      final tempDir = await getTemporaryDirectory();
      final String jobId = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = p.join(tempDir.path, 'ocr_clip_$jobId.png');
      final outputBase = p.join(tempDir.path, 'ocr_out_$jobId');

      // 1. Xóa Clipboard bằng CMD (Quá nhanh, không cần đổi)
      await Process.run('cmd', ['/c', 'echo off | clip']);

      // 2. Mở Snipping Tool
      // Dùng runInShell: true để gọi trực tiếp lệnh start của Windows mà không cần cmd /c
      await Process.run('start', ['ms-screenclip:'], runInShell: true);

      // 3. Đợi và lưu ảnh
      // Giảm Milliseconds xuống 100 để phản ứng nhanh gấp đôi ngay khi thả chuột
      bool captureSuccess = await _waitAndSaveClipboard(imagePath);
      if (!captureSuccess) return "USER_CANCELLED";

      // 4. OCR
      final result = await _runTesseract(imagePath, outputBase);

      _cleanupFiles([imagePath, '$outputBase.txt']);
      return result;
    } catch (e) {
      return "Lỗi hệ thống: $e";
    } finally {
      _isBusy = false;
    }
  }

  Future<bool> _waitAndSaveClipboard(String targetPath) async {
    final script =
        '''
      Add-Type -AssemblyName System.Windows.Forms
      Add-Type -AssemblyName System.Drawing
      \$timeout = (Get-Date).AddSeconds(15)
      while ((Get-Date) -lt \$timeout) {
          if ([Windows.Forms.Clipboard]::ContainsImage()) {
              \$img = [Windows.Forms.Clipboard]::GetImage()
              if (\$img -ne \$null) {
                  \$img.Save("$targetPath", [System.Drawing.Imaging.ImageFormat]::Png)
                  \$img.Dispose()
                  exit 0
              }
          }
          Start-Sleep -Milliseconds 100
      }
      exit 1
    ''';

    final result = await Process.run('powershell', [
      '-NoProfile',
      '-ExecutionPolicy',
      'Bypass',
      '-Command',
      script,
    ]);

    return result.exitCode == 0 && File(targetPath).existsSync();
  }

  Future<String> _runTesseract(String imagePath, String outputBase) async {
    final result = await Process.run(_resolvedTesseractPath!, [
      '--tessdata-dir',
      _cachedTessDataPath!,
      imagePath,
      outputBase,
      '-l',
      _ocrLanguages,
      '--psm',
      '6',
    ]);

    if (result.exitCode == 0) {
      final resFile = File('$outputBase.txt');
      if (await resFile.exists()) {
        // Đảm bảo đọc đúng UTF-8 để không lỗi font tiếng Việt
        return (await resFile.readAsString()).trim();
      }
    }
    return "Lỗi trích xuất chữ.";
  }

  // --- Các hàm tìm path giữ nguyên ---
  Future<String> _findTesseractPath() async {
    final String appDir = p.dirname(Platform.resolvedExecutable);
    final String prodPath = p.join(appDir, 'tesseract_bin', 'tesseract.exe');
    if (await File(prodPath).exists()) return prodPath;
    return r'D:\Windows\PackageManager\Scoop\shims\tesseract.exe';
  }

  Future<String> _prepareTessData() async {
    final String tessDataDir = AppPathService().tessDataPath;
    for (var lang in ['eng', 'vie']) {
      final file = File(p.join(tessDataDir, '$lang.traineddata'));
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/tessdata/$lang.traineddata');
        await file.create(recursive: true);
        await file.writeAsBytes(data.buffer.asUint8List());
      }
    }
    return tessDataDir;
  }

  void _cleanupFiles(List<String> paths) {
    for (var path in paths) {
      try {
        if (File(path).existsSync()) File(path).deleteSync();
      } catch (_) {}
    }
  }
}
