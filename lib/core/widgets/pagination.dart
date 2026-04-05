import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChange;
  final Color? activeColor;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Tránh hiển thị nếu chỉ có 1 trang hoặc không có dữ liệu
    if (totalPages <= 0) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Nút Back
        IconButton(
          onPressed: currentPage > 0
              ? () => onPageChange(currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
          color: activeColor,
        ),

        // Hiển thị vị trí trang
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (activeColor ?? Theme.of(context).primaryColor).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Trang ${currentPage + 1} / $totalPages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: activeColor ?? Theme.of(context).primaryColor,
            ),
          ),
        ),

        // Nút Next
        IconButton(
          onPressed: currentPage < totalPages - 1
              ? () => onPageChange(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
          color: activeColor,
        ),
      ],
    );
  }
}
