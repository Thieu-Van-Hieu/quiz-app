import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/library/notifiers/subject_notifier.dart';
import 'package:frontend/features/setting/data/app_config_repository.dart';
import 'package:frontend/features/setting/models/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_notifier.g.dart';

@riverpod
class AppConfigNotifier extends _$AppConfigNotifier {
  @override
  void build() {}

  Future<void> initAppConfig() async {
    final repo = ref.read(appConfigRepositoryProvider);
    await repo.initData();
    if (!ref.mounted) return;
    ref.invalidate(watchAppConfigProvider);
  }

  Future<void> updateConfig(AppConfig config) async {
    final repo = ref.read(appConfigRepositoryProvider);
    await repo.update(config);
    if (!ref.mounted) return;
    ref.invalidate(watchAppConfigProvider);
  }

  Future<void> clearStudyData() async {
    final repo = ref.read(appConfigRepositoryProvider);
    await repo.clearStudyData();
    if (!ref.mounted) return;
    ref.invalidate(learningSessionProvider);
    ref.invalidate(watchLearningSessionsProvider);
    ref.invalidate(watchSubjectsProvider);
  }
}

@riverpod
Stream<AppConfig?> watchAppConfig(Ref ref) {
  final repo = ref.watch(appConfigRepositoryProvider);
  return repo.watchConfig();
}
