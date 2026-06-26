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

  const AppTextField({
    super.key,
    required this.label,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.toastText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          maxLength: maxLength,
          keyboardType: keyboardType,
          focusNode: focusNode,
          autofocus: autofocus,
          maxLines: maxLines,
          expands: expands,
          textAlignVertical: textAlignVertical,
          style: const TextStyle(color: AppColors.toastText),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.secondaryText),
            filled: true,
            fillColor: AppColors.textFieldFill,
            prefixText: (prefixText != null && prefixText!.isNotEmpty)
                ? prefixText
                : null,
            suffixText: (suffixText != null && suffixText!.isNotEmpty)
                ? suffixText
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(
                color: AppColors.brandShadow,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
