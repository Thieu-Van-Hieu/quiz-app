import 'package:flutter/material.dart';

class SettingGroupCard extends StatelessWidget {
  final List<Widget> children;

  const SettingGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        // Giúp hiệu ứng bấm/ripple không đè lem ra ngoài 4 góc bo
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }
}
