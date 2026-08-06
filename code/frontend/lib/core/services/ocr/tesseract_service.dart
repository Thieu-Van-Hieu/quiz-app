import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:path/path.dart' as p;

class TesseractService {
  static const String _ocrLanguages = 'vie+eng';
  String? _cachedTessDataPath;
  String? _resolvedTesseractPath;

  Future<void> init() async {
    if (_cachedTessDataPath != null && _resolvedTesseractPath != null) return;
    _cachedTessDataPath = await _prepareTessData();
    _resolvedTesseractPath = await _findTesseractPath();
  }

  Future<String> run(String imagePath, String outputBase) async {
    await init();

    try {
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
          final text = (await resFile.readAsString()).trim();
          // Dọn dẹp file txt tạm sau khi đọc xong
          await resFile.delete();
          return text;
        }
      } else {
        debugPrint(
          "❌ Lỗi Tesseract (code ${result.exitCode}): ${result.stderr}",
        );
        return "Lỗi Tesseract: ${result.stderr}";
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi thực thi Tesseract process: $e");
      return "Lỗi hệ thống: $e";
    }

    return "Lỗi trích xuất chữ.";
  }

  /// Tìm đường dẫn Tesseract binary cho Linux, Windows và Debug
  Future<String> _findTesseractPath() async {
    final String appDir = p.dirname(Platform.resolvedExecutable);

    if (Platform.isLinux) {
      // 1. Tìm Bundled Tesseract trong linux/tesseract_bin/
      final String prodPath = p.join(appDir, 'tesseract_bin', 'tesseract');
      if (await File(prodPath).exists()) {
        // Cấp quyền thực thi (+x) trên Linux
        await Process.run('chmod', ['+x', prodPath]);
        debugPrint("🚀 Sử dụng Linux Bundled Tesseract: $prodPath");
        return prodPath;
      }

      // 2. Fallback về binary tesseract của hệ thống (apt)
      final sysResult = await Process.run('which', ['tesseract']);
      if (sysResult.exitCode == 0) {
        final sysPath = sysResult.stdout.toString().trim();
        if (sysPath.isNotEmpty) {
          debugPrint("🌐 Sử dụng System Tesseract: $sysPath");
          return sysPath;
        }
      }

      return 'tesseract';
    }

    if (Platform.isWindows) {
      // 1. Tìm Bundled Tesseract trong Inno Setup installer: {app}\tesseract_engine\
      final String enginePath = p.join(
        appDir,
        'tesseract_engine',
        'tesseract.exe',
      );
      if (await File(enginePath).exists()) return enginePath;

      // 2. Tìm Bundled Tesseract folder kiểu cũ: {app}\tesseract_bin\
      final String binPath = p.join(appDir, 'tesseract_bin', 'tesseract.exe');
      if (await File(binPath).exists()) return binPath;

      // 3. Path Debug dành cho môi trường máy cá nhân của bạn (Scoop)
      const debugPath = r'D:\Windows\PackageManager\Scoop\shims\tesseract.exe';
      if (await File(debugPath).exists()) return debugPath;

      return 'tesseract.exe';
    }

    throw UnsupportedError('Hệ điều hành chưa được hỗ trợ Tesseract.');
  }

  /// Unpack traineddata từ assets sang AppPathService().tessDataPath
  Future<String> _prepareTessData() async {
    final String tessDataDir = AppPathService().tessDataPath;
    final tessDirObj = Directory(tessDataDir);

    if (!await tessDirObj.exists()) {
      await tessDirObj.create(recursive: true);
    }

    for (var lang in ['eng', 'vie']) {
      final file = File(p.join(tessDataDir, '$lang.traineddata'));
      if (!await file.exists()) {
        try {
          final data = await rootBundle.load(
            'assets/tessdata/$lang.traineddata',
          );
          await file.writeAsBytes(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            flush: true,
          );
          debugPrint(
            "✅ Copy thành công asset $lang.traineddata -> $tessDataDir",
          );
        } catch (e) {
          debugPrint("❌ Lỗi copy asset $lang.traineddata: $e");
        }
      }
    }
    return tessDataDir;
  }
}
