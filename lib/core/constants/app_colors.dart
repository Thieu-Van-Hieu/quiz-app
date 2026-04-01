import 'package:flutter/material.dart';

class AppColors {
  // Dùng Colors chính chủ cho nhanh và chuẩn
  static const Color toastError = Colors.red;
  static const Color toastWarning = Colors.orange;
  static const Color toastInfo = Colors.deepOrange;

  // Màu Text và Shadow cho Toast (Dùng Hex cho sâu màu)
  static const Color toastText = Color(0xFF1F2937);
  static const Color toastShadow = Color(0x14000000); // 8% Alpha
  static const Color toastBackground = Colors.white;

  // --- UI COMPONENTS ---
  static const Color secondaryText = Color(0xFF636E72);
  static const Color searchBarBg = Color(0xFFF1F2F6);
}
