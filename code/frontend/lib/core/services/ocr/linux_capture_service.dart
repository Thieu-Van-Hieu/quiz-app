import 'dart:io';

import 'package:flutter/foundation.dart';

import 'capture_service.dart';

class LinuxCaptureService implements CaptureService {
  /// Tìm công cụ chụp màn hình có sẵn trên Linux (bao gồm Linux Mint 22)
  Future<String?> _findAvailableTool() async {
    final tools = [
      'xfce4-screenshooter', // Mặc định trên Linux Mint Xfce
      'gnome-screenshot', // Mặc định trên Ubuntu/GNOME
      'spectacle', // Mặc định trên KDE
      'maim', // Công cụ lightweight phổ biến
      'scrot', // Công cụ CLI phổ biến
      'grimshot', // Dành cho Wayland
    ];

    for (var tool in tools) {
      final result = await Process.run('which', [tool]);
      if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
        return tool;
      }
    }
    return null;
  }

  @override
  Future<bool> captureArea(String outputPath) async {
    final tool = await _findAvailableTool();

    if (tool == null) {
      debugPrint("❌ Không tìm thấy công cụ chụp màn hình nào trên hệ thống!");
      return false;
    }

    debugPrint("📸 Đang sử dụng công cụ screenshot: $tool");

    ProcessResult result;
    switch (tool) {
      case 'xfce4-screenshooter':
        // -r: region (chọn vùng), -s: save to path (lưu file)
        result = await Process.run('xfce4-screenshooter', [
          '-r',
          '-s',
          outputPath,
        ]);
        break;

      case 'gnome-screenshot':
        result = await Process.run('gnome-screenshot', [
          '-a',
          '-f',
          outputPath,
        ]);
        break;

      case 'spectacle':
        result = await Process.run('spectacle', ['-r', '-b', '-o', outputPath]);
        break;

      case 'maim':
        result = await Process.run('maim', ['-s', outputPath]);
        break;

      case 'scrot':
        result = await Process.run('scrot', ['-s', outputPath]);
        break;

      case 'grimshot':
        result = await Process.run('grimshot', ['save', 'area', outputPath]);
        break;

      default:
        return false;
    }

    // Kiểm tra xem file ảnh có được tạo ra thành công hay không
    final isSuccess = File(outputPath).existsSync();
    if (!isSuccess) {
      debugPrint(
        "⚠️ Người dùng hủy thao tác hoặc công cụ không tạo được file ảnh tại: $outputPath",
      );
    }
    return isSuccess;
  }
}
