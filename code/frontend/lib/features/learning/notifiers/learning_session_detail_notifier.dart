import 'package:frontend/features/learning/data/learning_session_detail_repository.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_session_detail_notifier.g.dart';

@riverpod
class LearningSessionDetailNotifier extends _$LearningSessionDetailNotifier {
  @override
  void build(int detailId) {
    // Khởi tạo logic dựa trên detailId nếu cần
  }

  // Chọn/Bỏ chọn đáp án
  Future<void> toggleAnswer(int detailId, Answer answer) async {
    if (!ref.mounted) return;
    final repo = ref.read(learningSessionDetailRepositoryProvider);
    await repo.toggleAnswer(detailId, answer);
    // Lưu ý: Do ObjectBox watch ở tầng Session,
    // nên khi detail thay đổi, Stream ở Session sẽ tự trigger lại UI.
  }

  // Nhấn nút kiểm tra (trong mode Study)
  Future<void> checkQuestion(int detailId) async {
    final repo = ref.read(learningSessionDetailRepositoryProvider);
    await repo.checkQuestion(detailId);
  }

  Future<void> toggleCheckStatus(int detailId) async {
    final repo = ref.read(learningSessionDetailRepositoryProvider);
    await repo.toggleCheckStatus(detailId);
  }
}

// Trong file notifier hoặc repository đều được
@riverpod
Stream<LearningSessionDetail?> watchLearningSessionDetail(
  Ref ref,
  int detailId,
) {
  final repo = ref.watch(learningSessionDetailRepositoryProvider);
  return repo.watchDetail(detailId);
}
