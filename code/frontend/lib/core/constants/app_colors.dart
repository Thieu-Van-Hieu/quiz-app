import 'package:flutter/material.dart';

class AppColors {
  // --- BRAND VARIANT (XANH LÁ MINT PASTEL - THEO GU CỦA BẠN) ---
  static const Color brand = Color(
    0xFFB9FBC0,
  ); // Xanh Mint Pastel dịu mát (Trùng tone CategoryColor.mint)
  static const Color brandDark = Color(
    0xFFA2EFA9,
  ); // Dùng làm hover & loading (Đậm hơn một chút nhưng vẫn pastel)
  static const Color brandShadow = Color(
    0xFF8AD191,
  ); // Chân đế 3D đổ bóng (Trầm xuống tự nhiên, không bị chói)

  // --- SLATE VARIANT (Màu Xám Xanh Đá Pastel mềm mại) ---
  static const Color slate = Color(
    0xFFB2BEC3,
  ); // Hạ tông xám xuống cho mềm tương thích với Mint
  static const Color slateDark = Color(0xFF9EAEB4);
  static const Color slateShadow = Color(0xFF839298);

  // --- INDIGO VARIANT (MÀU TÍM HOA CÀ / XANH CHÀM PASTEL - MỚI 🆕) ---
  static const Color indigo = Color(
    0xFFC7D2FE,
  ); // Tím chàm nhạt cực dịu (Ăn nhập hoàn toàn với palette pastel)
  static const Color indigoDark = Color(
    0xFFB4C2F9,
  ); // Tông sẫm hơn một chút cho hiệu ứng Hover/Loading
  static const Color indigoShadow = Color(
    0xFF9AA9E5,
  ); // Khối đế 3D đổ bóng vững chãi, trầm mịn

  // --- ORANGE/CORAL VARIANT (Màu Cam Đào Pastel mịn) ---
  static const Color orange = Color(
    0xFFFFD1BA,
  ); // Trùng tone CategoryColor.orange của bạn
  static const Color orangeDark = Color(0xFFF0BDA4);
  static const Color orangeShadow = Color(0xFFD6A48B);

  // --- UI COMPONENTS & CORE ---
  static const Color primary = Color(
    0xFFB9FBC0,
  ); // Đồng bộ primary theo màu Mint dịu
  static const Color surfaceVariant = Color(
    0xFFF5F6FA,
  ); // Nền xám trắng siêu nhẹ
  static const Color textMain = Color(
    0xFF2D3436,
  ); // Xám khói đậm (Giúp chữ nổi bật trên nền Mint nhạt)
  static const Color textWhite = Colors.white;
  static const Color transparent = Colors.transparent;

  // --- PASTEL TOAST ALERTS & STATUS ---
  static const Color success = Color(0xFFB9FBC0);
  static final Color successLight = const Color(
    0xFFB9FBC0,
  ).withValues(alpha: 0.2);
  static const Color error = Color(
    0xFFFFD1DC,
  ); // Đổi sang màu Hồng Pink Pastel cho đồng bộ cụm màu của bạn
  static const Color infoBlue = Color(0xFFBAE1FF); // Xanh Dương Pastel của bạn
  static const Color warningOrange = Color(0xFFFFD1BA); // Cam Pastel của bạn

  static const Color toastError = Color(0xFFFFD6D6);
  static const Color toastWarning = Color(0xFFFFF1BA); // Vàng Pastel của bạn
  static const Color toastInfo = Color(0xFFD1E8FF); // Xanh Trời Pastel của bạn
  static const Color toastText = Color(0xFF2D3436);
  static const Color toastShadow = Color(
    0x05000000,
  ); // 2% Alpha cho shadow cực kỳ nhẹ tiệp với màu pastel nhạt
  static const Color toastBackground = Colors.white;

  // --- INPUTS & SEARCH ---
  static const Color secondaryText = Color(0xFF95A5A6);
  static const Color searchBarBg = Color(0xFFF8F9FA);
  static const Color textFieldFill = Color(0xFFF1F3F5);

  static const Color actionEdit = Color(0xFFE0BBE4);
  static const Color actionEditDark = Color(0xFFCDA8D1);
  static const Color actionEditShadow = Color(0xFFB38EB8);

  // 2. Delete Variant (Hồng Cam Pastel/Đỏ nhạt dịu không gắt)
  static const Color actionDelete = Color(0xFFFFD1DC);
  static const Color actionDeleteDark = Color(0xFFECAEC0);
  static const Color actionDeleteShadow = Color(0xFFD193A5);

  // 3. Info Variant (Xanh Trời Pastel nhẹ nhàng)
  static const Color actionInfo = Color(0xFFD1E8FF);
  static const Color actionInfoDark = Color(0xFFBACFE6);
  static const Color actionInfoShadow = Color(0xFF9FB5CC);
}
