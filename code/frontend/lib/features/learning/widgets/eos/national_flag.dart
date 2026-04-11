import 'package:flutter/material.dart';

class NationalFlag extends StatelessWidget {
  const NationalFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.black12),
      ),
      child: const Center(
        child: Icon(Icons.star, color: Colors.yellow, size: 14),
      ),
    );
  }
}
