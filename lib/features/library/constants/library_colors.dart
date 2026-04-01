import 'package:flutter/material.dart';

class LibraryColors {
  // --- MÀU CƠ BẢN (Dùng Colors chính chủ) ---
  static const Color background = Color(
    0xFFF8F9FA,
  ); // Màu này Flutter không có sẵn chuẩn này nên giữ Hex
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0); // Màu xám nhẹ đặc thù

  // --- TEXT (Dùng Hex cho sâu màu) ---
  static const Color primaryText = Color(0xFF2D3436);
  static const Color secondaryText = Color(0xFF636E72);

  // --- ACCENT & ICONS ---
  static const Color accentColor =
      Colors.blue; // Thay cho 0xFF0984E3 nếu phen thấy Blue đủ dùng
  static final Color accentLight = Colors.blue.withValues(
    alpha: 0.1,
  ); // 10% Opacity (thay cho 0x1A...)

  static const Color folderIcon = Color(0xFFFAB1A0); // Màu cam san hô đặc thù
  static const Color quizIcon = Colors.blue;

  // --- ACTIONS (Delete/Error) ---
  static const Color deleteButton = Color(0xFFFF7675); // Đỏ pastel đặc thù
  static final Color deleteLight = const Color(
    0xFFFF7675,
  ).withValues(alpha: 0.1);

  // Shadow dùng mã Hex trực tiếp (vì shadow thường cố định độ mờ)
  static const Color shadow = Color(0x0A000000);
}
