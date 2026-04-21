import 'package:frontend/features/learning/data/learning_session_repository.dart';
import 'package:frontend/features/learning/models/learning_setting.dart';
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_session_notifier.g.dart';

@Riverpod(keepAlive: true)
class LearningSessionNotifier extends _$LearningSessionNotifier {
  // Không còn build(params) nữa, build trả về void hoặc giá trị mặc định
  @override
  void build() {}

  // Các hàm logic giữ nguyên, gọi qua ref.read(learningSessionNotifierProvider.notifier)

  Future<LearningSession> createSession({
    required int quizId,
    required LearningSetting setting,
  }) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    final result = await repo.createSession(quizId: quizId, setting: setting);
    ref.container.invalidate(watchLearningSessionsProvider);
    ref.container.invalidate(watchLearningSessionTotalPagesProvider);
    return result;
  }

  Future<LearningSession> retakeSession(int oldSessionId) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    final result = await repo.retakeSession(oldSessionId);

    // Invalidate để làm mới danh sách (xóa cache tất cả các params)
    ref.container.invalidate(watchLearningSessionsProvider);
    ref.container.invalidate(watchLearningSessionTotalPagesProvider);

    return result;
  }

  Future<LearningSession> createMistakeSession(int oldSessionId) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    final result = await repo.createMistakeSession(oldSessionId);

    // Invalidate sau khi thực hiện xong
    ref.container.invalidate(watchLearningSessionsProvider);
    ref.container.invalidate(watchLearningSessionTotalPagesProvider);

    return result;
  }

  Future<void> completeSession(int id) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    await repo.completeSession(id);

    // Invalidate sau khi update xong
    ref.container.invalidate(watchLearningSessionsProvider);
  }

  // Hàm update cực kỳ quan trọng, giờ gọi rất dễ
  Future<void> updateSession(LearningSession session) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    await repo.updateSession(session);
  }

  Future<void> deleteSession(int id) async {
    final repo = ref.read(learningSessionRepositoryProvider);
    await repo.deleteSession(id);
    ref.container.invalidate(watchLearningSessionProvider);
    ref.container.invalidate(watchLearningSessionsProvider);
    ref.container.invalidate(watchLearningSessionTotalPagesProvider);
  }
}

// --- ĐẨY CÁC STREAM RA NGOÀI ---

@riverpod
Stream<List<LearningSession>> watchLearningSessions(
  Ref ref,
  LearningSessionSearchParams params,
) {
  final repo = ref.watch(learningSessionRepositoryProvider);
  return repo.watchSessions(params);
}

@riverpod
Stream<LearningSession?> watchLearningSession(Ref ref, int id) {
  final repo = ref.watch(learningSessionRepositoryProvider);
  return repo.watchSession(id);
}

@riverpod
Stream<int> watchLearningSessionTotalPages(
  Ref ref,
  LearningSessionSearchParams params,
) {
  final repo = ref.watch(learningSessionRepositoryProvider);
  return repo.watchTotalPages(params);
}
