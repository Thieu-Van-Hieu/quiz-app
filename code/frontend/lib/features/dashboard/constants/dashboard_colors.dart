import 'package:flutter/material.dart';

class DashboardColors {
  // --- SIDEBAR (Tông Xanh Dương Pastel Nhẹ Nhàng) ---
  static const Color sidebarHeader = Color(
    0xFFD6E4F0,
  ); // Xanh xám pastel dịu mát (thay cho màu xám cũ)

  // Viền sidebar: Dùng màu xanh pastel trong suốt nhẹ
  static final Color sidebarBorder = const Color(
    0xFF74B9FF,
  ).withValues(alpha: 0.25);

  // Trạng thái đang chọn (Active): Màu nền xanh pastel mướt mắt
  static final Color sidebarActive = const Color(
    0xFF74B9FF,
  ).withValues(alpha: 0.18);

  // Trạng thái lướt qua (Hover): Cực kỳ nhẹ để tạo hiệu ứng mượt
  static final Color sidebarHover = const Color(
    0xFF74B9FF,
  ).withValues(alpha: 0.08);

  // --- NỀN & NỘI DUNG (PASTEL STYLE) ---
  static const Color backgroundContent = Color(
    0xFFF9FBFC,
  ); // Trắng sữa pha chút xanh pastel rất sạch và sáng

  // --- TEXT ---
  static const Color textPrimary = Color(
    0xFF34495E,
  ); // Xám xanh đá đậm (vừa đủ độ tương phản, vừa đúng điệu pastel)
}
