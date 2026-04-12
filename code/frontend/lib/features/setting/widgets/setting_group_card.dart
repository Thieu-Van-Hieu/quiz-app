import 'package:flutter/material.dart';

class SettingGroupCard extends StatelessWidget {
  final List<Widget> children;

  const SettingGroupCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: children),
    );
  }
}
