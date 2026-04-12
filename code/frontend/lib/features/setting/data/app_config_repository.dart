import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/setting/models/app_config.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_repository.g.dart';

@riverpod
AppConfigRepository appConfigRepository(Ref ref) {
  return AppConfigRepository();
}

class AppConfigRepository {
  final store = ObjectBoxService.instance.store;
  final _appConfigBox = ObjectBoxService.instance.get<AppConfig>();

  // 1. Khởi tạo dữ liệu (Dùng khi app mới cài)
  Future<void> initData() async {
    _appConfigBox.put(AppConfig());
  }

  // 2. Watch thay đổi (Trả về Stream để UI luôn update)
  Stream<AppConfig?> watchConfig() {
    return _appConfigBox
        .query(AppConfig_.id.equals(1))
        .watch(triggerImmediately: true)
        .map((query) => query.findFirst());
  }

  // 3. Update
  Future<void> update(AppConfig config) async {
    _appConfigBox.put(config);
  }

  // 4. Xóa dữ liệu học tập (Nhưng giữ lại Config)
  Future<void> clearStudyData() async {
    store.box<Subject>().removeAll();
    store.box<LearningSession>().removeAll();
  }
}
