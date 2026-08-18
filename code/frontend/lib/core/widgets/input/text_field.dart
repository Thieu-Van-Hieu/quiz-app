import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? prefixText;
  final String? suffixText;
  final int? maxLength;
  final int? maxLines;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry? contentPadding;
  final Axis layoutDirection;
  final bool enabled;
  final double? textFieldWidth;

  const AppTextField({
    super.key,
    this.label = "",
    this.hintText = "",
    this.prefixText,
    this.suffixText,
    this.controller,
    this.isPassword = false,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.autofocus = false,
    this.expands = false,
    this.textAlignVertical = TextAlignVertical.top,
    this.contentPadding,
    this.layoutDirection = Axis.vertical,
    this.enabled = true,
    this.textFieldWidth,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: AppColors.slate.withValues(alpha: 0.5),
        width: 1.5,
      ),
    );

    final disabledBorderStyle = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: AppColors.slate.withValues(alpha: 0.2),
        width: 1.5,
      ),
    );

    final textFieldWidget = TextField(
      controller: controller,
      enabled: enabled,
      obscureText: isPassword,
      maxLength: maxLength,
      keyboardType: keyboardType,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLines: maxLines,
      expands: expands,
      textAlignVertical: textAlignVertical,
      style: TextStyle(
        color: enabled ? AppColors.toastText : AppColors.secondaryText,
      ),
      decoration: InputDecoration(
        // Set constraints tối thiểu để không bị dẹt
        constraints: const BoxConstraints(minWidth: 48, minHeight: 40),
        isDense: true,
        // Giúp căn chỉnh padding nhỏ gọn chuẩn hơn
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.secondaryText),
        filled: true,
        fillColor: enabled
            ? AppColors.textFieldFill
            : AppColors.textFieldFill.withValues(alpha: 0.5),
        prefixText: (prefixText != null && prefixText!.isNotEmpty)
            ? prefixText
            : null,
        suffixText: (suffixText != null && suffixText!.isNotEmpty)
            ? suffixText
            : null,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: borderStyle,
        disabledBorder: disabledBorderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: const BorderSide(
            color: AppColors.brandShadow,
            width: 2.0,
          ),
        ),
      ),
    );

    if (label.isEmpty) {
      return textFieldWidget;
    }

    final labelWidget = Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: enabled ? AppColors.toastText : AppColors.secondaryText,
      ),
    );

    // Xử lý bố cục theo Hướng (Mặc định Column / Ngang Row)
    if (layoutDirection == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          labelWidget,
          const SizedBox(width: 8),
          // Thay vì Expanded ép dẹp, ta dùng SizedBox hoặc Flexible có minWidth
          if (textFieldWidth != null)
            SizedBox(width: textFieldWidth, child: textFieldWidget)
          else
            Flexible(child: textFieldWidget),
        ],
      );
    }

    // Mặc định dạng Dọc (Column)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [labelWidget, const SizedBox(height: 8), textFieldWidget],
    );
  }
}
