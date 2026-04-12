// Import tất cả các model của bạn
import 'package:flutter/cupertino.dart';
import 'package:frontend/core/services/path_service.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart'; // File generated bởi ObjectBox
import 'package:frontend/features/setting/models/app_config.dart';
import 'package:frontend/objectbox.g.dart';

class ObjectBoxService {
  /// Biến static lưu trữ instance duy nhất (Singleton)
  static ObjectBoxService? _instance;

  late final Store store;
  final Map<Type, Box> _boxes = {};

  /// Getter để lấy instance nhanh: ObjectBoxService.instance
  static ObjectBoxService get instance {
    if (_instance == null) {
      throw Exception(
        "ObjectBoxService chưa được khởi tạo! Hãy gọi await ObjectBoxService.create() ở main.dart",
      );
    }
    return _instance!;
  }

  /// Private Constructor
  ObjectBoxService._create(this.store) {
    _initBoxes();
  }

  /// Đăng ký tất cả Entity tại đây.
  /// Sau này thêm Model mới chỉ cần chạy build_runner rồi thêm 1 dòng register vào đây.
  void _initBoxes() {
    register<Answer>();
    register<Question>();
    register<Quiz>();
    register<Subject>();
    register<LearningSession>();
    register<LearningSessionDetail>();
    register<AppConfig>();
  }

  /// Hàm đăng ký generic
  void register<T>() {
    _boxes[T] = store.box<T>();
  }

  Box<T> get<T>() => _boxes[T] as Box<T>;

  /// Hàm khởi tạo Async (Chạy ở main.dart)
  static Future<ObjectBoxService> create() async {
    // Nếu đã khởi tạo rồi thì trả về luôn (Tránh mở nhiều Store lỗi DB)
    if (_instance != null) return _instance!;

    final String customPath = AppPathService().databasePath;
    debugPrint("ObjectBox Path chuẩn: $customPath");
    final store = await openStore(directory: customPath);

    _instance = ObjectBoxService._create(store);
    return _instance!;
  }

  /// Đóng store khi cần (Thường dùng trong Unit Test hoặc khi thoát App hoàn toàn)
  void dispose() {
    store.close();
  }
}
