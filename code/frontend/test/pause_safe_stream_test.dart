import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/extensions/stream_extension.dart';

/// Giả lập `store.watch<T>()` của ObjectBox: lúc bị pause thì bỏ qua sự kiện
StreamController<int> lossyOnPause() {
  var paused = false;
  late StreamController<int> source;
  source = StreamController<int>(
    onPause: () => paused = true,
    onResume: () => paused = false,
  );
  return _Lossy(source, () => paused);
}

class _Lossy implements StreamController<int> {
  final StreamController<int> inner;
  final bool Function() isPausedFn;

  _Lossy(this.inner, this.isPausedFn);

  @override
  void add(int event) {
    if (!isPausedFn()) inner.add(event);
  }

  @override
  Stream<int> get stream => inner.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('stream gốc của ObjectBox mất sự kiện khi bị pause', () async {
    final source = lossyOnPause();
    final received = <int>[];
    final sub = source.stream.listen(received.add);
    sub.pause();
    source.add(1);
    sub.resume();
    await pumpEventQueue();
    expect(received, isEmpty);
    await sub.cancel();
  });

  test(
    'pauseSafe giữ sự kiện mới nhất lúc pause và phát lại khi resume',
    () async {
      final source = lossyOnPause();
      final received = <int>[];
      final sub = source.stream.pauseSafe().listen(received.add);

      source.add(1);
      await pumpEventQueue();
      expect(received, [1]);

      sub.pause();
      source.add(2);
      source.add(3);
      await pumpEventQueue();
      expect(received, [1]);

      sub.resume();
      await pumpEventQueue();
      expect(received, [1, 3]);

      source.add(4);
      await pumpEventQueue();
      expect(received, [1, 3, 4]);
      await sub.cancel();
    },
  );
}
