import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_session_detail_repository.g.dart';

@riverpod
LearningSessionDetailRepository learningSessionDetailRepository(Ref ref) {
  return LearningSessionDetailRepository();
}

class LearningSessionDetailRepository {
  final _learningSessionDetailBox = ObjectBoxService.instance
      .get<LearningSessionDetail>();

  Stream<LearningSessionDetail?> watchDetail(int detailId) {
    // Tạo query tìm đúng cái Detail đó
    final query = _learningSessionDetailBox.query(
      LearningSessionDetail_.id.equals(detailId),
    );

    // Trả về stream, mỗi khi Box có thay đổi (put/delete), nó sẽ phát lại data
    return query
        .watch(triggerImmediately: true)
        .map(((query) => query.findFirst()));
  }

  Future<void> updateSessionDetail(LearningSessionDetail detail) async {
    _learningSessionDetailBox.put(detail);
  }

  Future<void> resetDetailForRetry(int detailId) async {
    final detail = _learningSessionDetailBox.get(detailId);
    if (detail == null) return;

    // Reset trạng thái
    detail.isChecked = false;
    detail.isPassed = false;
    detail.selectedAnswers.clear();

    _learningSessionDetailBox.put(detail);
  }

  Future<void> toggleAnswer(int id, Answer answer) async {
    final detail = _learningSessionDetailBox.get(id);
    if (detail == null || detail.isChecked) return;

    if (detail.selectedAnswers.any((a) => a.id == answer.id)) {
      detail.selectedAnswers.removeWhere((a) => a.id == answer.id);
    } else {
      detail.selectedAnswers.add(answer);
    }

    _learningSessionDetailBox.put(detail);
  }

  Future<void> checkQuestion(int id) async {
    final detail = _learningSessionDetailBox.get(id);
    if (detail == null || detail.isChecked) return;

    final selected = detail.selectedAnswers;
    final correctAnswers =
        detail.question.target?.answers.where((a) => a.isCorrect).toList() ??
        [];
    detail.isChecked = true;
    detail.isPassed =
        (selected.length == correctAnswers.length) &&
        selected.every((s) => correctAnswers.any((c) => c.id == s.id));

    _learningSessionDetailBox.put(detail);
  }

  Future<void> updatePassStatus(int id, bool status) async {
    final detail = _learningSessionDetailBox.get(id);
    if (detail == null) return;
    detail.isPassed = status;
    if (!status) {
      detail.selectedAnswers.clear();
    }
    _learningSessionDetailBox.put(detail);
  }

  Future<void> toggleCheckStatus(int id) async {
    final detail = _learningSessionDetailBox.get(id);
    if (detail == null) return;

    // Đảo trạng thái hiện tại
    detail.isChecked = !detail.isChecked;
    // Chỉ tính toán đúng/sai khi người dùng nhấn "Show" (chuyển từ false sang true)
    if (detail.isChecked) {
      final selected = detail.selectedAnswers;
      final correctAnswers =
          detail.question.target?.answers.where((a) => a.isCorrect).toList() ??
          [];

      detail.isPassed =
          (selected.length == correctAnswers.length) &&
          selected.every((s) => correctAnswers.any((c) => c.id == s.id));
    }
    _learningSessionDetailBox.put(detail);
  }
}
