import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Cần để dùng FilteringTextInputFormatter
import 'package:frontend/features/learning/constants/learning_colors.dart';

class RetroNumberInput extends StatefulWidget {
  final ValueNotifier<double> valueNotifier;
  final double minValue;
  final double maxValue;
  final double step;

  const RetroNumberInput({
    super.key,
    required this.valueNotifier,
    this.minValue = 8.0,
    this.maxValue = 30.0,
    this.step = 1.0,
  });

  @override
  State<RetroNumberInput> createState() => _RetroNumberInputState();
}

class _RetroNumberInputState extends State<RetroNumberInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với giá trị hiện tại
    _controller = TextEditingController(
      text: widget.valueNotifier.value.toInt().toString(),
    );

    // Lắng nghe thay đổi từ ValueNotifier để cập nhật lại TextField (khi ấn nút tăng/giảm)
    widget.valueNotifier.addListener(_onNotifierChanged);
  }

  void _onNotifierChanged() {
    final newValue = widget.valueNotifier.value.toInt().toString();
    if (_controller.text != newValue) {
      _controller.text = newValue;
    }
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_onNotifierChanged);
    _controller.dispose();
    super.dispose();
  }

  // Hàm xử lý khi người dùng nhập trực tiếp
  void _handleManualInput(String input) {
    if (input.isEmpty) return;

    double? newValue = double.tryParse(input);
    if (newValue != null) {
      // Giới hạn trong khoảng min/max
      if (newValue < widget.minValue) newValue = widget.minValue;
      if (newValue > widget.maxValue) newValue = widget.maxValue;

      widget.valueNotifier.value = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: LearningColors.retroInputBackground,
        border: Border.all(color: LearningColors.retroInputBorderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút Giảm
          _buildArrowButton(
            icon: Icons.arrow_left,
            onTap: () => widget.valueNotifier.value = max(
              widget.minValue,
              widget.valueNotifier.value - widget.step,
            ),
          ),

          // Ô nhập giá trị trực tiếp
          Container(
            width: 35,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: LearningColors.retroInputBorderLight,
                  width: 0.5,
                ),
              ),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              cursorColor: LearningColors.windowsBlack,
              // Chỉ cho phép nhập số
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: LearningColors.windowsBlack,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none, // Bỏ gạch chân mặc định
              ),
              onChanged: _handleManualInput,
              onSubmitted: (value) {
                // Khi nhấn Enter, đảm bảo text hiển thị đúng giá trị đã clamp
                _controller.text = widget.valueNotifier.value
                    .toInt()
                    .toString();
              },
            ),
          ),

          // Nút Tăng
          _buildArrowButton(
            icon: Icons.arrow_right,
            onTap: () => widget.valueNotifier.value = min(
              widget.maxValue,
              widget.valueNotifier.value + widget.step,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Thêm bàn tay cho đúng ý bạn lúc nãy
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Icon(icon, size: 22, color: LearningColors.windowsBlack),
      ),
    );
  }
}
