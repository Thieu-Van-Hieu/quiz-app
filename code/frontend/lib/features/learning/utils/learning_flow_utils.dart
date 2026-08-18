import 'package:flutter/foundation.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';

class LearningFlowUtils {
  /// Khoảng cách lặp lại câu sai.
  /// - `reviewOffset == 0`: Standard Mode (chạy tuyến tính +1)
  /// - `reviewOffset > 0`: Adaptive Mode (lặp lại câu sai sau ít nhất `reviewOffset` bước)
  final int reviewOffset;

  final List<int> _historyIndices = [];

  LearningFlowUtils({this.reviewOffset = 0});

  /// Danh sách lịch sử index đã qua trong phiên làm việc (Read-only)
  List<int> get historyIndices => List.unmodifiable(_historyIndices);

  /// Reset lịch sử lượt làm
  void reset() {
    debugPrint('[LearningFlowUtils] Reset history indices.');
    _historyIndices.clear();
  }

  /// Xem trước index tiếp theo mà KHÔNG làm thay đổi `_historyIndices`
  int peekNextIndex({
    required List<LearningSessionDetail> details,
    required int currentIndex,
  }) {
    return _calculateNextIndex(
      details: details,
      currentIndex: currentIndex,
      history: _historyIndices,
    );
  }

  /// Tính toán index của câu tiếp theo VÀ ghi nhận `currentIndex` vào lịch sử
  int getNextIndex({
    required List<LearningSessionDetail> details,
    required int currentIndex,
  }) {
    debugPrint(
      '\n[LearningFlowUtils] --- getNextIndex (Current: $currentIndex, Offset: $reviewOffset) ---',
    );

    final simulatedHistory = [..._historyIndices, currentIndex];
    final nextIndex = _calculateNextIndex(
      details: details,
      currentIndex: currentIndex,
      history: simulatedHistory,
      isExecuting: true,
    );

    if (reviewOffset > 0) {
      _historyIndices.add(currentIndex);
      debugPrint('[LearningFlowUtils] History updated: $_historyIndices');
    }

    debugPrint('[LearningFlowUtils] Next calculated index -> $nextIndex');
    return nextIndex;
  }

  /// Hàm tính toán dùng chung (Pure Function) không làm mutate state
  /// Hàm tính toán dùng chung (Pure Function) không làm mutate state
  int _calculateNextIndex({
    required List<LearningSessionDetail> details,
    required int currentIndex,
    required List<int> history,
    bool isExecuting = false,
  }) {
    // 1. STANDARD MODE (Chạy tuyến tính): reviewOffset <= 0
    if (reviewOffset <= 0) {
      if (currentIndex < details.length - 1) {
        return currentIndex + 1;
      }
      return -1; // Đã tới câu cuối cùng
    }

    // 2. ADAPTIVE MODE: reviewOffset > 0

    // Lấy danh sách các index đang bị FAILED
    final failedIndices = <int>[];
    for (int i = 0; i < details.length; i++) {
      if (details[i].isPassed == false) {
        failedIndices.add(i);
      }
    }

    // Sắp xếp các câu sai theo thời gian xuất hiện lần cuối trong history (Từ cũ nhất đến mới nhất)
    failedIndices.sort((a, b) {
      final lastSeenA = history.lastIndexOf(a);
      final lastSeenB = history.lastIndexOf(b);
      return lastSeenA.compareTo(lastSeenB);
    });

    // 🚨 ĐIỀU KIỆN 1: Nếu danh sách câu sai đã đầy slot (>= reviewOffset)
    // Ép quay lại làm câu sai lâu nhất ngay lập tức mà KHÔNG cho làm câu mới nữa
    if (failedIndices.length >= reviewOffset) {
      final oldestFailedIndex = failedIndices.first;
      if (isExecuting) {
        debugPrint(
          '[LearningFlowUtils] Reached max failed capacity (${failedIndices.length} >= $reviewOffset) -> Forcing review on index $oldestFailedIndex',
        );
      }
      return oldestFailedIndex;
    }

    // 🚨 ĐIỀU KIỆN 2: Kiểm tra từng câu sai xem đã trôi qua đủ bước chưa
    // Khi bạn sai 4 câu + làm 1 câu mới = tổng 5 bước trôi qua -> Câu sai đầu tiên chạm mốc offset=5
    for (final failedIndex in failedIndices) {
      final lastSeenStep = history.lastIndexOf(failedIndex);

      if (lastSeenStep != -1) {
        // Tính tổng số lượt làm đã trôi qua kể từ khi làm câu sai này
        final stepsSinceLastSeen = history.length - lastSeenStep;

        if (stepsSinceLastSeen >= reviewOffset) {
          if (isExecuting) {
            debugPrint(
              '[LearningFlowUtils] Failed question index $failedIndex reached review offset ($stepsSinceLastSeen >= $reviewOffset steps ago) -> Scheduling now!',
            );
          }
          return failedIndex;
        }
      }
    }

    // 3. Nếu chưa chạm ngưỡng ép buộc ôn tập -> Cho phép làm CÂU MỚI TẾP THEO (isPassed == null)

    // Tìm câu chưa làm từ vị trí hiện tại trở đi
    for (int i = currentIndex + 1; i < details.length; i++) {
      if (details[i].isPassed == null) {
        return i;
      }
    }

    // Tìm câu chưa làm từ đầu danh sách
    for (int i = 0; i < details.length; i++) {
      if (details[i].isPassed == null) {
        return i;
      }
    }

    // 4. Nếu đã làm hết câu mới trong đề nhưng vẫn còn câu chưa Pass
    // Lấy câu sai lâu nhất để tiếp tục cho làm lại
    if (failedIndices.isNotEmpty) {
      final oldestFailedIndex = failedIndices.first;
      if (isExecuting) {
        debugPrint(
          '[LearningFlowUtils] All new questions answered. Re-evaluating oldest failed question index $oldestFailedIndex',
        );
      }
      return oldestFailedIndex;
    }

    // Đã PASS toàn bộ câu hỏi
    return -1;
  }
}
