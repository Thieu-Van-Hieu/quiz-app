import 'package:flutter/material.dart';

class RetroDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? initValue;
  final ValueChanged<T?> onChanged;

  const RetroDropdown({
    super.key,
    required this.items,
    required this.initValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Loại bỏ hiệu ứng highlight tròn khi click theo kiểu hiện đại
        splashColor: Colors.transparent,
        highlightColor: const Color(0xFF000080), // Màu Navy khi chọn
      ),
      child: Container(
        height: 28,
        width: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          // Border tạo hiệu ứng lõm xuống cho ô nhập liệu
          border: Border(
            top: BorderSide(color: Color(0xFF808080), width: 1.5),
            left: BorderSide(color: Color(0xFF808080), width: 1.5),
            bottom: BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
            right: BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: initValue,
            isExpanded: true,
            elevation: 0,
            // Quan trọng: Bỏ đổ bóng nhòe để không giống Context Menu
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.zero,
            // Không bo góc
            icon: _buildRetroIcon(),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'MS Sans Serif', // Ưu tiên font classic nếu có
            ),
            // Padding cho text đang hiển thị
            padding: const EdgeInsets.only(left: 6),
            // Tùy chỉnh danh sách khi xổ xuống
            items: items.map((DropdownMenuItem<T> item) {
              return DropdownMenuItem<T>(
                value: item.value,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  // Render text của từng item
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    child: item.child,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  // Nút bấm Dropdown kiểu Win95
  Widget _buildRetroIcon() {
    return Container(
      width: 20,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFFD4D0C8), // Màu xám Retro
        border: Border(
          top: BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
          left: BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
          bottom: BorderSide(color: Color(0xFF808080), width: 1.5),
          right: BorderSide(color: Color(0xFF808080), width: 1.5),
        ),
      ),
      child: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
    );
  }
}
