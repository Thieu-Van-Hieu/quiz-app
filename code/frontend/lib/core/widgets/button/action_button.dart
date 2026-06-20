import 'package:frontend/core/constants/app_colors.dart'; // Thay đường dẫn package cho đúng ứng dụng mới
import 'package:flutter/material.dart';

enum ActionType { edit, delete, export, info }

enum ActionButtonStyle { filled, tonal, outline }

class AppActionButton extends StatefulWidget {
  final VoidCallback? onTap; // Cho phép null để xử lý trạng thái disable
  final ActionType actionType;
  final ActionButtonStyle style;
  final IconData? icon;
  final String? tooltip;

  const AppActionButton({
    super.key,
    required this.onTap,
    this.actionType = ActionType.info,
    this.style = ActionButtonStyle
        .tonal, // Mặc định dùng Tonal phẳng tinh tế cho icon nhỏ, hoặc Filled nếu muốn nổi bật
    this.icon,
    this.tooltip,
  });

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  // Trả về icon mặc định theo ActionType
  IconData _getDefaultIcon() {
    switch (widget.actionType) {
      case ActionType.edit:
        return Icons.edit_rounded;
      case ActionType.delete:
        return Icons.delete_outline_rounded;
      case ActionType.export:
        return Icons.file_download_outlined;
      case ActionType.info:
        return Icons.info_outline_rounded;
    }
  }

  // Trả về chuỗi mô tả mặc định cho Tooltip nếu dev quên truyền
  String _getDefaultTooltip() {
    switch (widget.actionType) {
      case ActionType.edit:
        return "Chỉnh sửa";
      case ActionType.delete:
        return "Xóa bỏ";
      case ActionType.export:
        return "Xuất file";
      case ActionType.info:
        return "Chi tiết";
    }
  }

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------
    // 1. PHÂN TÁCH BẢNG MÀU 3D THEO ACTION TYPE
    // ----------------------------------------------------
    Color baseColor;
    Color darkColor;
    Color shadowColor;
    Color contrastIconColor; // Màu icon tối đè lên bản Filled để chống chói

    switch (widget.actionType) {
      case ActionType.edit:
        baseColor = AppColors.actionEdit;
        darkColor = AppColors.actionEditDark;
        shadowColor = AppColors.actionEditShadow;
        contrastIconColor = const Color(0xFF5D3A63); // Tím đậm trầm
        break;
      case ActionType.delete:
        baseColor = AppColors.actionDelete;
        darkColor = AppColors.actionDeleteDark;
        shadowColor = AppColors.actionDeleteShadow;
        contrastIconColor = const Color(0xFF7C3E4F); // Đỏ hồng gạch đậm
        break;
      case ActionType.export:
        baseColor = AppColors.orange;
        darkColor = AppColors.orangeDark;
        shadowColor = AppColors.orangeShadow;
        contrastIconColor = const Color(0xFF7E4B31); // Đỏ gạch trầm
        break;
      case ActionType.info:
        baseColor = AppColors.actionInfo;
        darkColor = AppColors.actionInfoDark;
        shadowColor = AppColors.actionInfoShadow;
        contrastIconColor = const Color(0xFF34495E); // Xám xanh Navy đậm
        break;
    }

    final Color activeBaseColor = _isHovered ? darkColor : baseColor;

    // ----------------------------------------------------
    // 2. ĐỘNG HÓA STYLE (Filled 3D, Tonal phẳng, Outline phẳng)
    // ----------------------------------------------------
    Color backgroundColor = Colors.transparent;
    Color iconColor = AppColors.textMain;
    Color currentShadowColor = Colors.transparent;
    Border? border;
    double shadowDepth =
        2.5; // Nút hành động nhỏ chỉ cần lún 2.5px là vừa khít mắt

    final bool isDisabled = widget.onTap == null;

    if (isDisabled) {
      backgroundColor =
          (widget.style == ActionButtonStyle.filled ||
              widget.style == ActionButtonStyle.tonal)
          ? AppColors.textFieldFill
          : Colors.transparent;
      iconColor = AppColors.secondaryText;
      shadowDepth = 0.0;
      if (widget.style == ActionButtonStyle.outline) {
        border = Border.all(
          color: AppColors.secondaryText.withValues(alpha: 0.4),
          width: 1.5,
        );
      }
    } else {
      switch (widget.style) {
        case ActionButtonStyle.filled:
          backgroundColor = activeBaseColor;
          iconColor = contrastIconColor; // Chống chói lóa nền sáng
          currentShadowColor = shadowColor;
          break;

        case ActionButtonStyle.tonal:
          backgroundColor = baseColor.withValues(
            alpha: _isHovered ? 0.3 : 0.15,
          );
          iconColor =
              shadowColor; // Lấy màu shadow làm màu icon tạo chiều sâu pastel cực đẹp
          shadowDepth = 0.0;
          break;

        case ActionButtonStyle.outline:
          backgroundColor = _isHovered
              ? baseColor.withValues(alpha: 0.1)
              : Colors.transparent;
          iconColor = shadowColor;
          border = Border.all(color: baseColor, width: 1.5);
          shadowDepth = 0.0;
          break;
      }
    }

    // Tính toán độ lún cơ học khi Tap xuống
    final double topOffset = isDisabled ? 0 : (_isPressed ? shadowDepth : 0);
    final double bottomShadowHeight = isDisabled
        ? shadowDepth
        : (_isPressed ? 0 : shadowDepth);

    // Kích thước cố định mini xinh xắn cho nút hành động (vừa vặn 36x36px)
    const double btnSize = 36.0;

    // ----------------------------------------------------
    // 3. DỰNG LAYOUT VỚI TOOLTIP
    // ----------------------------------------------------
    return Tooltip(
      message: widget.tooltip ?? _getDefaultTooltip(),
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        cursor: isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: isDisabled
              ? null
              : (_) => setState(() => _isPressed = true),
          onTapUp: isDisabled
              ? null
              : (_) {
                  setState(() => _isPressed = false);
                  widget.onTap?.call();
                },
          onTapCancel: isDisabled
              ? null
              : () => setState(() => _isPressed = false),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              width: btnSize,
              height:
                  btnSize + shadowDepth, // Chừa khoảng trống dịch chuyển bóng
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 40,
                ), // Click phản hồi cực bốc
                margin: EdgeInsets.only(
                  top: topOffset,
                  bottom: shadowDepth - topOffset,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle, // 🆕 Bo tròn xoe kute dạng kẹo ngọt
                  border: border,
                  boxShadow:
                      bottomShadowHeight > 0 &&
                          currentShadowColor != Colors.transparent
                      ? [
                          BoxShadow(
                            color: currentShadowColor,
                            offset: Offset(0, bottomShadowHeight),
                            blurRadius: 0,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Icon(
                    widget.icon ?? _getDefaultIcon(),
                    size: 18, // Kích thước icon chuẩn mực
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
