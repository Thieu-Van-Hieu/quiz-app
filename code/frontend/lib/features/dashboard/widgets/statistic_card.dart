import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // Giảm padding dọc một chút để tối ưu không gian
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Kiểm tra nếu chiều cao quá thấp (ngưỡng 60px)
          bool isOverflowingHeight = constraints.maxHeight < 60;

          if (isOverflowingHeight) {
            // GIAO DIỆN KHI BỊ OVERFLOW: Label và Value chung 1 hàng, bỏ Icon
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18, // Giảm nhẹ size chữ để vừa hàng ngang
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          }

          // GIAO DIỆN BÌNH THƯỜNG: Column 2 hàng + Icon
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(icon, color: color.withValues(alpha: 0.6), size: 18),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}
