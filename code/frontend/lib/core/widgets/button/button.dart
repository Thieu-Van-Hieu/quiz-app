import 'package:frontend/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum ButtonVariant {
  brand,
  brandOutlined,
  slate,
  slateOutlined,
  indigo,
  danger,
}

enum ButtonSize { small, medium, big }

class AppButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isDisabled;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isDisabled = false,
    this.isLoading = false,
    this.variant = ButtonVariant.brand,
    this.size = ButtonSize.medium,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color shadowColor;
    Color fgColor;
    Border? border;

    // Phối màu thông minh cho cả hệ đặc (Solid) và hệ viền nổi (Outlined)
    switch (widget.variant) {
      case ButtonVariant.brand:
        bgColor = widget.isLoading
            ? AppColors.brandDark
            : (_isHovered ? AppColors.brandDark : AppColors.brand);
        shadowColor = AppColors.brandShadow;
        fgColor = const Color(0xFF2B5B34); // Xanh rừng già tương phản Mint
        break;

      case ButtonVariant.brandOutlined:
        bgColor = _isHovered ? const Color(0xFFF2FBF7) : Colors.white;
        shadowColor = const Color(0xFFCBD5E1);
        fgColor = const Color(0xFF2B5B34);
        border = Border.all(color: AppColors.brand, width: 2.5);
        break;

      case ButtonVariant.slate:
        bgColor = widget.isLoading
            ? AppColors.slateDark
            : (_isHovered ? AppColors.slateDark : AppColors.slate);
        shadowColor = AppColors.slateShadow;
        fgColor = AppColors.textWhite;
        break;

      case ButtonVariant.slateOutlined:
        bgColor = _isHovered ? const Color(0xFFF8FAFC) : Colors.white;
        shadowColor = const Color(0xFFE2E8F0);
        fgColor = const Color(0xFF475569);
        border = Border.all(color: const Color(0xFFCBD5E1), width: 2.5);
        break;

      case ButtonVariant.indigo:
        bgColor = widget.isLoading
            ? AppColors.indigoDark
            : (_isHovered ? AppColors.indigoDark : AppColors.indigo);
        shadowColor = AppColors.indigoShadow;
        fgColor = const Color(
          0xFF3730A3,
        ); // Chữ màu Indigo đậm tương phản cao trên nền nhạt
        break;

      case ButtonVariant.danger:
        bgColor = widget.isLoading
            ? AppColors.orangeDark
            : (_isHovered ? AppColors.orangeDark : AppColors.orange);
        shadowColor = AppColors.orangeShadow;
        fgColor = const Color(0xFF7E4B31);
        break;
    }

    double horizontalPadding;
    double verticalPadding;
    double fontSize;

    switch (widget.size) {
      case ButtonSize.small:
        horizontalPadding = 16;
        verticalPadding = 10;
        fontSize = 13;
        break;
      case ButtonSize.medium:
        horizontalPadding = 24;
        verticalPadding = 14;
        fontSize = 14;
        break;
      case ButtonSize.big:
        horizontalPadding = 32;
        verticalPadding = 18;
        fontSize = 16;
        break;
    }

    // Logic tính toán độ lún cơ học khi Click
    final bool effectivelyDisabled =
        widget.isDisabled || widget.isLoading || widget.onPressed == null;
    final double topOffset = (effectivelyDisabled && !widget.isLoading)
        ? 0
        : (_isPressed || widget.isLoading ? 4 : 0);
    final double bottomShadowHeight = (effectivelyDisabled && !widget.isLoading)
        ? 4
        : (_isPressed || widget.isLoading ? 0 : 4);

    return MouseRegion(
      cursor: effectivelyDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: effectivelyDisabled
            ? null
            : (_) => setState(() => _isPressed = true),
        onTapUp: effectivelyDisabled
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onPressed?.call();
              },
        onTapCancel: effectivelyDisabled
            ? null
            : () => setState(() => _isPressed = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: widget.isDisabled ? 0.4 : (widget.isLoading ? 0.8 : 1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            margin: EdgeInsets.only(top: topOffset, bottom: 4 - topOffset),
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              borderRadius: BorderRadius.circular(16),
              boxShadow: bottomShadowHeight > 0
                  ? [
                      BoxShadow(
                        color: shadowColor,
                        offset: Offset(0, bottomShadowHeight),
                        blurRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding - (border != null ? 2.5 : 0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.isLoading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Đang xử lý...",
                          style: TextStyle(
                            color: fgColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  Opacity(
                    opacity: widget.isLoading ? 0.0 : 1.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: fgColor, size: fontSize + 4),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: fgColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
