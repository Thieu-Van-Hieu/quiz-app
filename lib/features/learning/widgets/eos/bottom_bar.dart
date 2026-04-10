import 'package:flutter/material.dart';

class EosBottomBar extends StatelessWidget {
  final List<Widget> leftActions;
  final List<Widget> rightActions;
  final Color bgColor;

  const EosBottomBar({
    super.key,
    this.leftActions = const [],
    this.rightActions = const [],
    this.bgColor = const Color(0xFFD4D0C8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      // Tạo viền trên cho đúng chất Windows cổ điển
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: Colors.white, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: leftActions),
          Row(children: rightActions),
        ],
      ),
    );
  }
}
