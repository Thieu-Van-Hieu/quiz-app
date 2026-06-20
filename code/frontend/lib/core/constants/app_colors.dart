import 'package:flutter/material.dart';

class AppColors {
  // --- PASTEL TOAST ALERTS ---
  static const Color toastError = Color(0xFFFFD6D6); // Đỏ pastel nhạt
  static const Color toastWarning = Color(0xFFFFEAA7); // Vàng cam pastel
  static const Color toastInfo = Color(
    0xFFDFF9FB,
  ); // Xanh dương/cyan pastel nhạt

  // Màu Text và Shadow cho Toast (Giữ nền trắng, text trầm nhẹ)
  static const Color toastText = Color(
    0xFF2D3436,
  ); // Xám khói đậm (mềm hơn màu đen thuần)
  static const Color toastShadow = Color(
    0x0A000000,
  ); // 4% Alpha cho shadow mịn màng đúng chuẩn pastel
  static const Color toastBackground = Colors.white;

  // --- UI COMPONENTS (PASTEL STYLE) ---
  static const Color secondaryText = Color(0xFFB2BEC3); // Xám pastel nhạt
  static const Color searchBarBg = Color(0xFFF5F6FA); // Trắng xám cực nhẹ
  static const Color textFieldFill = Color(
    0xFFF1F2F6,
  ); // Xám pastel nhẹ cho input
  static const Color transparent = Colors.transparent;

  // Status & Alerts (Pastel Thống Nhất)
  static const Color success = Color(0xFF55EFC4); // Xanh lá pastel sáng
  static final Color successLight = const Color(
    0xFF55EFC4,
  ).withValues(alpha: 0.15);
  static const Color infoBlue = Color(0xFF74B9FF); // Xanh dương pastel
  static const Color warningOrange = Color(0xFFFAB1A0); // Cam đào pastel
}
