import 'package:flutter/material.dart';

class SubjectPagination extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageChange;

  const SubjectPagination({
    super.key,
    required this.currentPage,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 0
              ? () => onPageChange(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text("Trang ${currentPage + 1}"),
        IconButton(
          onPressed: () => onPageChange(currentPage + 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
