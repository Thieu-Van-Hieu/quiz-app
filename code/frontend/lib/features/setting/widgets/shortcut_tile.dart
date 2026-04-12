import 'package:flutter/material.dart';
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
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
      trailing: Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (assignedKeys.isEmpty)
            ActionChip(
              mouseCursor: SystemMouseCursors.click,
              label: const Text("Gán phím", style: TextStyle(fontSize: 10)),
              onPressed: onTap,
            )
          else
            ...assignedKeys.map(
              (key) => InputChip(
                mouseCursor: SystemMouseCursors.click,
                label: Text(
                  key.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onDeleted: () => onRemoveKey(key),
                deleteIconColor: Colors.redAccent,
                backgroundColor: Colors.blue.withValues(alpha: 0.05),
              ),
            ),
          IconButton(
            mouseCursor: SystemMouseCursors.click,
            icon: const Icon(
              Icons.add_circle_outline,
              size: 20,
              color: Colors.blue,
            ),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
