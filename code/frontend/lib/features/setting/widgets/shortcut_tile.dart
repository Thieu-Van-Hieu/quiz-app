import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/setting/enums/physical_key.dart';

class ShortcutTile extends StatelessWidget {
  final String label;
  final List<PhysicalKey> assignedKeys;
  final VoidCallback onTap;
  final Function(PhysicalKey) onRemoveKey;

  const ShortcutTile({
    super.key,
    required this.label,
    required this.assignedKeys,
    required this.onTap,
    required this.onRemoveKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      trailing: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          if (assignedKeys.isEmpty)
            AppButton(
              label: "Gán phím",
              variant: ButtonVariant.indigo,
              size: ButtonSize.small,
              onPressed: onTap,
            )
          else
            ...assignedKeys.map((key) => _buildKeyBadge(key)),

          AppActionButton(
            icon: Icons.add_circle_outline_rounded,
            onTap: onTap,
            actionType: ActionType.edit,
          ),
        ],
      ),
    );
  }

  // 🎨 Custom Keyboard Badge siêu gọn gàng
  Widget _buildKeyBadge(PhysicalKey key) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
      decoration: BoxDecoration(
        color: AppColors.slate.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.brand.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key.readableName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
              fontFamily: 'monospace', // Tạo cảm giác nút bàn phím thật
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onRemoveKey(key),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.actionDelete.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
