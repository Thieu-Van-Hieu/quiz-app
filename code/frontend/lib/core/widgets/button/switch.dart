import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.toastText,
          ),
        ),
        const SizedBox(width: 4),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.brand,
            activeThumbColor: AppColors.brandShadow,
            inactiveTrackColor: AppColors.textFieldFill,
            inactiveThumbColor: AppColors.slate,
            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.brandShadow.withValues(alpha: 0.5);
              }
              return AppColors.slate.withValues(alpha: 0.3);
            }),
            mouseCursor: SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }
}
