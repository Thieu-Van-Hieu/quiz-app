import 'package:flutter/material.dart';

class EosVerticalSplitter extends StatefulWidget {
  final ValueNotifier<double> widthNotifier;
  final double minWidth;
  final double maxWidth;
  final Color color;
  final Color hoverColor;

  const EosVerticalSplitter({
    super.key,
    required this.widthNotifier,
    this.minWidth = 50.0,
    this.maxWidth = 400.0,
    this.color = const Color(0xFFB71C1C), // Màu đỏ đậm đặc trưng EOS
    this.hoverColor = Colors.redAccent,
  });

  @override
  State<EosVerticalSplitter> createState() => _EosVerticalSplitterState();
}

class _EosVerticalSplitterState extends State<EosVerticalSplitter> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Logic xử lý kéo thả
      onHorizontalDragUpdate: (details) {
        double newVal = widget.widthNotifier.value + details.delta.dx;
        // Clamp giá trị trong khoảng min/max để tránh vỡ layout
        if (newVal >= widget.minWidth && newVal <= widget.maxWidth) {
          widget.widthNotifier.value = newVal;
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Container(
          width: 4,
          // Đổi màu nhẹ khi di chuột vào để tăng trải nghiệm người dùng
          color: _isHovering ? widget.hoverColor : widget.color,
          // Thêm một chút đổ bóng nhẹ nếu muốn (optional)
          child: VerticalDivider(
            width: 4,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}
