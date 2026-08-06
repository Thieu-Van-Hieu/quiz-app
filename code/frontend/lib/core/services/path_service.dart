import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppPathService {
  static final AppPathService _instance = AppPathService._internal();

  factory AppPathService() => _instance;

  AppPathService._internal();

  late final String _rootPath;
  bool _isInitialized = false;

  String get rootPath => _rootPath;

  String get databasePath => p.join(_rootPath, 'database');

  String get tessDataPath => p.join(_rootPath, 'tessdata');

  String get tempPath => p.join(_rootPath, 'temp');

  Future<void> init() async {
    if (_isInitialized) return;

    final String folderName = kDebugMode ? 'QuizApp_Debug' : 'QuizApp';

    if (Platform.isWindows) {
      // 1. Windows: Giữ nguyên lấy rootPath từ %APPDATA%/QuizApp
      final String? roamingPath = Platform.environment['APPDATA'];
      if (roamingPath == null) throw Exception("Không tìm thấy AppData");
      _rootPath = p.join(roamingPath, folderName);

      // 2. Windows: Tự động tìm và xóa thư mục rác Mr.NoBody nếu có
      await _cleanMrNoBodyFolder();
    } else if (Platform.isLinux) {
      // 3. Linux: Dùng đường dẫn tiêu chuẩn (~/.local/share/...)
      final Directory appSupportDir = await getApplicationSupportDirectory();
      _rootPath =
      kDebugMode ? p.join(appSupportDir.path, '.debug') : appSupportDir.path;
    } else {
      // Các nền tảng khác nếu có
      final Directory appSupportDir = await getApplicationSupportDirectory();
      _rootPath = appSupportDir.path;
    }

    // 4. Khởi tạo tất cả thư mục làm việc (Gốc, database, tessdata, temp)
    final foldersToCreate = [_rootPath, databasePath, tessDataPath, tempPath];
    for (var path in foldersToCreate) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        debugPrint("📁 Đã tạo thư mục [$folderName]: $path");
      }
    }

    _isInitialized = true;
  }

  /// Quét và xóa sạch thư mục Mr.NoBody sinh ra do path_provider trên Windows
  Future<void> _cleanMrNoBodyFolder() async {
    try {
      final Directory appSupportDir = await getApplicationSupportDirectory();

      // Đường dẫn sinh ra bởi path_provider thường có dạng AppData/Roaming/Mr.NoBody/QuizApp
      // appSupportDir.path chính là đường dẫn đích danh đó
      final Directory mrNoBodyAppDir = Directory(appSupportDir.path);

      if (await mrNoBodyAppDir.exists()) {
        debugPrint("🗑️ Phát hiện thư mục rác: ${mrNoBodyAppDir
            .path}. Tiến hành xóa...");
        await mrNoBodyAppDir.delete(recursive: true);

        // Thử xóa luôn thư mục cha 'Mr.NoBody' nếu nó trống sau khi xóa app folder
        final Directory mrNoBodyParentDir = mrNoBodyAppDir.parent;
        if (await mrNoBodyParentDir.exists()) {
          final List<FileSystemEntity> remainingFiles = await mrNoBodyParentDir
              .list().toList();
          if (remainingFiles.isEmpty) {
            await mrNoBodyParentDir.delete();
            debugPrint("🗑️ Đã xóa thư mục cha rỗng: ${mrNoBodyParentDir.path}");
          }
        }
      }
    } catch (e) {
      // Ghi log lỗi nếu thư mục đang bị hệ thống khóa hoặc không xóa được, không làm crash app
      debugPrint("⚠️ Không thể dọn dẹp thư mục Mr.NoBody: $e");
    }
  }
}