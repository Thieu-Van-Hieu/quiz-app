import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';

class EosClock extends HookWidget {
  final int initialSeconds;
  final bool isCountDown;
  final VoidCallback? onFinished;
  final Color? textColor;

  const EosClock({
    super.key,
    required this.initialSeconds,
    this.isCountDown = true,
    this.onFinished,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng useState để giữ giá trị giây
    final seconds = useState(initialSeconds);

    // useEffect xử lý logic Timer tự động (tương đương initState + dispose)
    final onFinishedRef = useRef(onFinished);
    onFinishedRef.value = onFinished;

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (isCountDown) {
          if (seconds.value <= 0) {
            t.cancel();
            onFinishedRef.value?.call();
          } else {
            seconds.value -= 1;
          }
        } else {
          seconds.value += 1;
        }
      });
      return timer.cancel;
    }, [isCountDown]);

    String formatTime(int total) {
      int m = total ~/ 60;
      int s = total % 60;
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    return Text(
      formatTime(seconds.value),
      style: TextStyle(
        fontSize: 36,
        color: LearningColors.eosPrimaryBlue,
        fontWeight: FontWeight.bold,
        fontFamily: 'Courier', // Font máy tính cổ điển
      ),
    );
  }
}
