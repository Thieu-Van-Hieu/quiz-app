import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/dashboard/widgets/activity_chart_card.dart';
import 'package:frontend/features/dashboard/widgets/overall_statistic_grid.dart';
import 'package:frontend/features/dashboard/widgets/recent_session_item.dart';
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = useMemoized(
      () => LearningSessionSearchParams(page: 0, size: 50),
    );
    final sessionsAsync = ref.watch(watchLearningSessionsProvider(params));

    return ColoredBox(
      color: const Color(0xFFF8F9FA),
      child: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) return _buildEmptyState();

          // TÍNH TOÁN STATS VÀ CHART DATA TRONG MỘT LƯỢT ĐỂ TỐI ƯU
          final dashboardData = useMemoized(() {
            // 1. Tính Stats tổng quát
            final totalQuestions = sessions.fold(
              0,
              (sum, s) => sum + s.learningSessionDetails.length,
            );
            final totalSeen = sessions.fold(0, (sum, s) => sum + s.totalSeen);
            final completedSessions = sessions
                .where((s) => s.isCompleted)
                .toList();
            final avgAccuracy = completedSessions.isEmpty
                ? 0.0
                : completedSessions.fold(
                        0.0,
                        (sum, s) => sum + s.accuracyRate,
                      ) /
                      completedSessions.length;

            // 2. Gom nhóm dữ liệu cho biểu đồ 7 ngày qua
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            Map<int, double> dailyStats = {for (var i = 0; i < 7; i++) i: 0};

            for (var session in sessions) {
              final sessionDate = DateTime(
                session.startTime.year,
                session.startTime.month,
                session.startTime.day,
              );
              final difference = today.difference(sessionDate).inDays;

              if (difference >= 0 && difference < 7) {
                // index: 0 là 6 ngày trước, index: 6 là hôm nay
                int index = 6 - difference;
                dailyStats[index] =
                    (dailyStats[index] ?? 0) +
                    session.learningSessionDetails.length;
              }
            }

            return (
              totalQuestions: totalQuestions,
              totalSeen: totalSeen,
              avgAccuracy: avgAccuracy,
              totalSessions: sessions.length,
              chartData: dailyStats,
            );
          }, [sessions]);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: OverallStatisticGrid(
                  totalQuestions: dashboardData.totalQuestions,
                  totalSeen: dashboardData.totalSeen,
                  avgAccuracy: dashboardData.avgAccuracy,
                  totalSessions: dashboardData.totalSessions,
                ),
              ),

              // TRUYỀN DATA THẬT VÀO CHART
              SliverToBoxAdapter(
                child: ActivityChartCard(data: dashboardData.chartData),
              ),

              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Phiên học gần đây",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final session = sessions[index];
                    return RecentSessionItem(
                      session: session,
                      onTap: () =>
                          context.go(LearningRoutes.sessionPath(session.id)),
                    );
                  }, childCount: sessions.length > 5 ? 5 : sessions.length),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Lỗi: $e")),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Chưa có dữ liệu thống kê",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Hãy bắt đầu học để thấy tiến độ!",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
