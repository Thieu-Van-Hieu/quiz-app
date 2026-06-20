import 'package:flutter/material.dart';

class LibraryColors {
  // --- NỀN & THẺ (SURFACES - PASTEL) ---
  static const Color background = Color(0xFFF7F9FA); // Trắng xám dịu mát
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(
    0xFFEDF1F5,
  ); // Đường kẻ nhạt hơn, tiệp với pastel
  static const Color shadow = Color(0x06000000); // Giảm còn 2.3% cho mượt
  static const Color cardShadow = Color(
    0x0B000000,
  ); // Giảm còn 4.3% cho nổi khối nhẹ nhàng

  // --- CHỮ (TYPOGRAPHY) ---
  static const Color primaryText = Color(
    0xFF2C3E50,
  ); // Xám xanh navy đậm (sang và dịu mắt hơn đen)
  static const Color secondaryText = Color(0xFF7F8C8D); // Xám pastel vừa
  static const Color disabledText = Color(
    0xFFBDC3C7,
  ); // Xám pastel nhạt cho trạng thái tắt

  // --- MÀU NHẤN & ICON (ACCENT - PASTEL BLUE) ---
  static const Color accentColor = Color(0xFF74B9FF); // Xanh dương pastel sáng
  static const Color accentLight = Color(
    0xFFEBF5FF,
  ); // Xanh cực nhạt, mướt mắt cho highlight
  static const Color editBorder = Color(
    0xFFADCEDD,
  ); // Viền xanh xám pastel nhẹ khi chỉnh sửa

  static const Color folderIcon = Color(
    0xFFFFB8B1,
  ); // Cam san hô pastel nguyên bản nhạt
  static const Color quizIcon = Color(
    0xFF81ECEC,
  ); // Xanh Mint/Cyan pastel cho bộ câu hỏi
  static const Color quizHighlight = Color(
    0xFFE8FFFF,
  ); // Nền highlight xanh mint siêu nhạt

  // --- TRẠNG THÁI CÂU HỎI (QUIZ STATES - PASTEL) ---
  static const Color correct = Color(0xFF55EFC4); // Xanh lá pastel (Đúng)
  static const Color correctBackground = Color(
    0xFFE8FDF7,
  ); // Nền xanh lá siêu nhạt cho câu đúng

  // --- HÀNH ĐỘNG (ACTIONS) ---
  static const Color deleteButton = Color(
    0xFFFF7675,
  ); // Đỏ hồng pastel nhạt thời thượng
  static const Color deleteLight = Color(
    0xFFFFF0F0,
  ); // Nền đỏ pastel siêu nhạt cho nút xóa

  static const Color editButton = Color(
    0xFFFAB1A0,
  ); // Đổi sang màu cam đào pastel cho nút sửa
  static const Color infoIcon = Color(
    0xFFA29BFE,
  ); // Tím pastel mộng mơ cho icon thông tin

  // --- INPUTS ---
  static const Color inputBackground = Color(
    0xFFF1F2F6,
  ); // Nền input xám mịn pastel
}
