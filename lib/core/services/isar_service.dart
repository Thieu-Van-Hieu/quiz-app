import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static Isar? _instance;

  // Getter để lấy instance mọi lúc mọi nơi
  static Isar get instance {
    if (_instance == null) {
      throw Exception(
        "Isar chưa được khởi tạo. Hãy gọi init() trong main.dart",
      );
    }
    return _instance!;
  }

  static Future<void> init() async {
    if (_instance != null) return;

    final dir = await getApplicationDocumentsDirectory();

    // TODO: Thêm các Collection vào đây khi có model mới
    _instance = await Isar.open(
      [],
      directory: dir.path,
      inspector: true, // Bật cái này để debug DB trên Browser (cực xịn)
    );
  }
}
