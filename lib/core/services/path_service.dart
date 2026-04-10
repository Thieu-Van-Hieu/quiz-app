import 'dart:io';

import 'package:path/path.dart' as p;

class AppPathService {
  static final AppPathService _instance = AppPathService._internal();
  factory AppPathService() => _instance;
  AppPathService._internal();

  late final String _rootPath;

  // Các đường dẫn con
  String get databasePath => p.join(_rootPath, 'database');
  String get tessDataPath => p.join(_rootPath, 'tessdata');
  String get tempPath => p.join(_rootPath, 'temp');

  /// Khởi tạo và tạo sẵn cấu trúc thư mục
  Future<void> init() async {
    // 1. Lấy Roaming Path sạch sẽ
    final String? roamingPath = Platform.environment['APPDATA'];
    if (roamingPath == null) throw Exception("Không tìm thấy AppData");

    // 2. Thiết lập thư mục gốc của App
    _rootPath = p.join(roamingPath, 'QuizApp');

    // 3. Danh sách các folder cần tạo sẵn
    final foldersToCreate = [_rootPath, databasePath, tessDataPath, tempPath];

    // 4. Tạo tất cả một lượt
    for (var path in foldersToCreate) {
      final dir = Directory(path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        print("📁 Đã tạo thư mục: $path");
      }
    }
  }
}
