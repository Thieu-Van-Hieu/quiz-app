import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/exceptions/app_exception.dart';

extension FutureToastExtension<T> on Future<T> {
  Future<T?> withToast(BuildContext context) async {
    try {
      return await this;
    } catch (error) {
      String message = "Đã có lỗi xảy ra!";
      Color iconColor = AppColors.toastError; // Dùng Colors cho nhanh
      IconData icon = Icons.error_outline_rounded;

      if (error is EntityAlreadyExistsException) {
        message = error.message;
        iconColor = AppColors.toastWarning; // Dùng Colors cho nhanh
        icon = Icons.warning_amber_rounded;
      } else if (error is ValidationException) {
        message = error.message;
        iconColor = AppColors.toastInfo; // Dùng Colors cho nhanh
        icon = Icons.info_outline_rounded;
      }

      if (context.mounted) {
        DelightToastBar(
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: const Duration(seconds: 3),
          builder: (context) => Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 20),
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.toastBackground, // Màu nền trắng cơ bản
                borderRadius: BorderRadius.circular(8),
                // Dùng withValues thay cho withOpacity để tránh deprecated
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors
                        .toastShadow, // Hex cho shadow để chỉnh độ mờ chuẩn
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: AppColors
                            .toastText, // Dùng Hex cho text để màu sâu hơn đen thường
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).show(context);
      }
      return null;
    }
  }
}
