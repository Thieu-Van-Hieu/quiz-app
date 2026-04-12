import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/setting/enums/physical_key.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:objectbox/objectbox.dart';

part 'app_config.mapper.dart';

@MappableClass()
@Entity()
class AppConfig with AppConfigMappable {
  @Id(assignable: true)
  int id;

  String fontFamily;
  double fontSize;
  bool enableQuickAnswer;
  bool isMouseEnabled;

  // ObjectBox lưu chuỗi JSON này
  String internalKeyBindings;

  AppConfig({
    this.id = 1,
    this.fontFamily = AppStrings.defaultFontFamily,
    this.fontSize = AppStrings.defaultFontSize,
    this.enableQuickAnswer = true,
    this.isMouseEnabled = true,
    this.internalKeyBindings = '{}',
  });

  // 1. CHUYỂN SANG LIST: Để một action có nhiều phím tắt
  set keyBindings(Map<ShortcutAction, List<PhysicalKey>> map) {
    // Đảm bảo các mapper đã được khởi tạo
    ShortcutActionMapper.ensureInitialized();
    PhysicalKeyMapper.ensureInitialized();

    internalKeyBindings = MapperContainer.globals.toJson(map);
  }

  Map<ShortcutAction, List<PhysicalKey>> get keyBindings {
    try {
      ShortcutActionMapper.ensureInitialized();
      PhysicalKeyMapper.ensureInitialized();

      return MapperContainer.globals
          .fromJson<Map<ShortcutAction, List<PhysicalKey>>>(
            internalKeyBindings,
          );
    } catch (e) {
      return {};
    }
  }
}
