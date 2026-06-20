import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class LibraryColors {
  // --- NỀN & THẺ (SURFACES - 3D PASTEL) ---
  static const Color background = Color(
    0xFFF8F9FA,
  ); // Trắng xám dịu mát (trùng với searchBarBg)
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFEDF1F5); // Đường kẻ rãnh nhạt mảnh
  static const Color shadow = Color(
    0x06000000,
  ); // Đổ bóng đổ khối siêu mịn 2.3%
  static const Color cardShadow = Color(
    0x0B000000,
  ); // Khối nổi nhẹ nhàng cho Card 4.3%

  // --- CHỮ (TYPOGRAPHY) ---
  static const Color primaryText = AppColors
      .textMain; // Đồng bộ dùng xám khói đậm (0xFF2D3436) thay cho xám navy cũ
  static const Color secondaryText =
      AppColors.secondaryText; // Xám pastel nhẹ nhàng (0xFF95A5A6)
  static const Color disabledText = Color(
    0xFFBDC3C7,
  ); // Xám nhạt cho trạng thái khóa

  // --- MÀU NHẤN & ICON (ACCENT - CHUYỂN TỪ XANH DƯƠNG CHÓI SANG MINT/SLATE HỆ THỐNG) ---
  static const Color accentColor =
      AppColors.brand; // Màu nhấn chủ đạo là màu Mint (0xFFB9FBC0)
  static const Color accentLight = Color(
    0xFFF2FBF7,
  ); // Nền highlight xanh mint siêu nhạt mướt mắt
  static const Color editBorder = Color(
    0xFFCBD5E1,
  ); // Viền khối xám nhạt mịn màng khi chỉnh sửa

  // --- ICONS & HIGHLIGHTS TRÊN CARD ---
  static const Color folderIcon =
      AppColors.orange; // Icon thư mục dùng màu Cam Đào Pastel (0xFFFFD1BA)
  static const Color quizIcon =
      AppColors.brand; // Icon bộ đề dùng màu Mint Pastel đồng bộ luôn
  static const Color quizHighlight = Color(
    0xFFF2FBF7,
  ); // Nền highlight đồng điệu với Mint nhạt

  // --- TRẠNG THÁI CÂU HỎI (QUIZ STATES - ĐỒNG BỘ MINT PASTEL) ---
  static const Color correct =
      AppColors.brand; // Đúng = Màu Mint kẹo ngọt của app
  static const Color correctBackground = Color(
    0xFFEAFEEF,
  ); // Nền xanh Mint siêu nhạt

  // --- HÀNH ĐỘNG TRÊN NÚT BẤM (ACTIONS - ĐỒNG BỘ 100% HỆ THỐNG) ---
  // 1. Nhóm nút Xóa
  static const Color deleteButton = AppColors
      .actionDelete; // Hồng cam pastel dịu (0xFFFFD1DC) thay cho đỏ gắt cũ
  static const Color deleteLight = Color(
    0xFFFFF0F3,
  ); // Nền hồng pastel siêu nhạt tương ứng

  // 2. Nhóm nút Sửa
  static const Color editButton =
      AppColors.actionEdit; // Tím đào pastel mộng mơ (0xFFE0BBE4) mướt mắt

  // 3. Nhóm nút Thông tin/Học tập bổ trợ
  static const Color infoIcon =
      AppColors.actionInfo; // Xanh trời pastel nhẹ nhàng (0xFFD1E8FF)

  // --- INPUTS ---
  static const Color inputBackground =
      AppColors.textFieldFill; // Nền input xám mịn (0xFFF1F3F5)
}
