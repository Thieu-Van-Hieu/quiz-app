import 'package:flutter/material.dart';

class LibraryColors {
  // --- NỀN & THẺ (SURFACES) ---
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x0A000000); // 4% Black
  static const Color cardShadow = Color(
    0x14000000,
  ); // 8% Black cho nổi khối hơn

  // --- CHỮ (TYPOGRAPHY) ---
  static const Color primaryText = Color(0xFF2D3436);
  static const Color secondaryText = Color(0xFF636E72);
  static const Color disabledText = Color(0xFFB2BEC3);

  // --- MÀU NHẤN & ICON (ACCENT) ---
  static const Color accentColor = Colors.blue;
  // Xanh cực nhạt cho nền highlight (thay cho opacity 0.1)
  static const Color accentLight = Color(0xFFE3F2FD);
  // Xanh nhạt vừa cho Border khi Edit
  static const Color editBorder = Color(0xFF90CAF9);

  static const Color folderIcon = Color(0xFFFAB1A0); // Cam san hô
  static const Color quizIcon = Colors.blue;
  static const Color quizHighlight = Color(0xFFE3F2FD);

  // --- TRẠNG THÁI CÂU HỎI (QUIZ STATES) ---
  // Xanh lá cho đáp án đúng
  static const Color correct = Colors.green;
  // Nền xanh lá cực nhạt (Solid) cho item đúng
  static const Color correctBackground = Color(0xFFE8F5E9);

  // --- HÀNH ĐỘNG (ACTIONS) ---
  static const Color deleteButton = Color(0xFFFF7675); // Đỏ pastel
  // Nền đỏ nhạt (Solid) cho nút xóa
  static const Color deleteLight = Color(0xFFFFEBEE);

  // Màu bổ sung cho các button/icon khác
  static const Color editButton = Colors.blue;
  static const Color infoIcon = Color(0xFF74B9FF);

  // --- INPUTS ---
  // Màu nền cho TextField khi không focus (thay cho opacity)
  static const Color inputBackground = Color(0xFFF1F3F5);
}
