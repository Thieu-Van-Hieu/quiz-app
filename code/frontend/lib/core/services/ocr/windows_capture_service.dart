import 'dart:io';

import 'capture_service.dart';

class WindowsCaptureService implements CaptureService {
  @override
  Future<bool> captureArea(String targetPath) async {
    // 1. Xóa Clipboard
    await Process.run('cmd', ['/c', 'echo off | clip']);

    // 2. Gọi Windows Snipping Tool
    await Process.run('start', ['ms-screenclip:'], runInShell: true);

    // 3. Đợi ảnh trong Clipboard và lưu
    return await _waitAndSaveClipboard(targetPath);
  }

  Future<bool> _waitAndSaveClipboard(String targetPath) async {
    String script =
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
}
