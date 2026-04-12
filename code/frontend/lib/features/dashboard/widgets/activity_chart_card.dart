import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityChartCard extends StatelessWidget {
  final Map<int, double> data; // Nhận data từ DashboardPage

  const ActivityChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Lấy giá trị lớn nhất trong Map dữ liệu
    double maxQuestions = 0;
    if (data.isNotEmpty) {
      maxQuestions = data.values.reduce((a, b) => a > b ? a : b);
    }

    // Nếu tất cả bằng 0, ta để mặc định là 10 để biểu đồ không bị lỗi hiển thị
    double displayMaxY = maxQuestions > 0 ? maxQuestions : 10;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hoạt động 7 ngày qua",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                // Gán maxY bằng giá trị lớn nhất
                maxY: displayMaxY,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final now = DateTime.now();
                        final date = now.subtract(
                          Duration(days: 6 - value.toInt()),
                        );
                        const weekdays = [
                          'T2',
                          'T3',
                          'T4',
                          'T5',
                          'T6',
                          'T7',
                          'CN',
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            weekdays[date.weekday - 1],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (index) {
                  return _makeGroupData(
                    index,
                    data[index] ?? 0,
                    // Highlight cột hôm nay (index cuối cùng)
                    index == 6
                        ? Colors.blue
                        : Colors.blue.withValues(alpha: 0.3),
                    displayMaxY,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Colors
                .grey
                .shade50, // Vẫn giữ bóng mờ để thấy cái "khung" của các ngày khác
          ),
        ),
      ],
    );
  }
}
