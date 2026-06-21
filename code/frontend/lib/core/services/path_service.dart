import 'dart:io';

import 'package:flutter/foundation.dart'; // Import để dùng kDebugMode
import 'package:path/path.dart' as p;

class AppPathService {
  static final AppPathService _instance = AppPathService._internal();

  factory AppPathService() => _instance;

  AppPathService._internal();

  late final String _rootPath;

  String get databasePath => p.join(_rootPath, 'database');

  String get tessDataPath => p.join(_rootPath, 'tessdata');

  String get tempPath => p.join(_rootPath, 'temp');

  Future<void> init() async {
    final String? roamingPath = Platform.environment['APPDATA'];
    if (roamingPath == null) throw Exception("Không tìm thấy AppData");

    // Tự động chọn tên thư mục dựa trên chế độ chạy của App
    // Nếu là Debug thì tên là QuizApp_Debug, Release thì là QuizApp
    final String folderName = kDebugMode ? 'QuizApp_Debug' : 'QuizApp';

    // 2. Thiết lập thư mục gốc của App dựa trên mode
    _rootPath = p.join(roamingPath, folderName);

    // 3. Danh sách các folder cần tạo sẵn
    final foldersToCreate = [_rootPath, databasePath, tessDataPath, tempPath];

    // 4. Tạo tất cả một lượt
    for (var path in foldersToCreate) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        debugPrint("📁 Đã tạo thư mục [$folderName]: $path");
      }
    }
  }
}
