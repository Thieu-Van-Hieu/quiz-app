import 'package:flutter/material.dart';

class DashboardColors {
  // --- SIDEBAR (Dùng Colors.blue làm gốc + withValues) ---
  static const Color sidebarHeader = Color(0xFF9FB6D3); // Màu xanh xám đặc thù, giữ Hex
  
  // 0x33 tương đương 20% alpha
  static final Color sidebarBorder = Colors.blue.withValues(alpha: 0.2); 
  
  // 0x26 tương đương 15% alpha
  static final Color sidebarActive = Colors.blue.withValues(alpha: 0.15);
  
  // 0x1A tương đương 10% alpha
  static final Color sidebarHover = Colors.blue.withValues(alpha: 0.1);

  // --- NỀN & NỘI DUNG ---
  static const Color backgroundContent = Color(0xFFF5F7F9); // Màu nền đặc thù, giữ Hex
  
  // --- TEXT ---
  static const Color textPrimary = Color(0xFF2D2D2D); // Màu xám đậm sâu, giữ Hex
}
