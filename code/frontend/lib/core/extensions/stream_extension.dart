import 'dart:async';

extension PauseSafeStreamExtension<T> on Stream<T> {
  /// Bọc stream watch của ObjectBox để không mất thay đổi khi bị pause.
  ///
  /// Riverpod 3 pause provider của các trang đang ẩn (vd. tab khác trong
  /// IndexedStack). Nhưng ObjectBox xử lý pause không đúng:
  /// - `store.watch<T>()` đóng hẳn observer khi pause → thay đổi lúc đó bị bỏ qua
  /// - `Query.watch()` khi resume tạo subscription mới, bỏ luôn subscription cũ
  ///   đang giữ các sự kiện → môn học tạo ở trang khác không hiện ra
  ///
  /// Ở đây stream nguồn luôn chạy; lúc bị pause chỉ giữ lại sự kiện mới nhất
  /// và phát ra khi resume.
  Stream<T> pauseSafe() {
    late final StreamController<T> controller;
    StreamSubscription<T>? subscription;
    T? pending;
    var hasPending = false;

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          (event) {
            if (controller.isPaused) {
              pending = event;
              hasPending = true;
            } else {
              controller.add(event);
            }
          },
          onError: controller.addError,
          onDone: controller.close,
        );
      },
      // Không pause stream nguồn (xem giải thích ở trên)
      onPause: () {},
      onResume: () {
        if (!hasPending) return;
        hasPending = false;
        final event = pending as T;
        pending = null;
        controller.add(event);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }
}
