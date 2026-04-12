import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/widgets/learning_session_detail/header_statistic.dart';
import 'package:frontend/features/learning/widgets/learning_session_detail/question_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SessionFilter {
  all,
  correct,
  wrong, // Cho Study/Exam
  seen,
  notSeen, // Cho Practice
}

class LearningSessionDetailPage extends HookConsumerWidget {
  final int sessionId;

  const LearningSessionDetailPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(watchLearningSessionProvider(sessionId));

    // State quản lý bộ lọc
    final filter = useState<SessionFilter>(SessionFilter.all);

    return sessionAsync.when(
      data: (session) {
        if (session == null) {
          return const Center(child: Text("Phiên học không tồn tại"));
        }

        // Logic lọc dữ liệu
        final allDetails = session.learningSessionDetails;
        final filteredDetails = allDetails.where((d) {
          switch (filter.value) {
            case SessionFilter.correct:
              return d.isCorrect == true;
            case SessionFilter.wrong:
              return d.isCorrect == false;
            case SessionFilter.seen:
              return d.isSeen == true;
            case SessionFilter.notSeen:
              return d.isSeen == false;
            default:
              return true;
          }
        }).toList();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header & Filter Tabs
            SliverToBoxAdapter(
              child: SessionHeaderStatistic(
                session: session,
                currentFilter: filter.value,
                onFilterChanged: (newFilter) => filter.value = newFilter,
              ),
            ),

            // 2. Danh sách câu hỏi sau khi lọc
            if (filteredDetails.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "Không có câu hỏi nào trong mục này",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SessionQuestionCard(
                      detail: filteredDetails[index],
                      mode: session.learningModeEnum,
                      onTap: () => _showReviewSheet(
                        context,
                        filteredDetails[index],
                        session.learningModeEnum,
                      ),
                    ),
                    childCount: filteredDetails.length,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Lỗi: $e")),
    );
  }

  // --- BOTTOM REVIEW SHEET ---

  void _showReviewSheet(
    BuildContext context,
    LearningSessionDetail detail,
    LearningMode mode,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                "NỘI DUNG",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                detail.question.target?.content ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 40),
              const Text(
                "ĐÁP ÁN",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildAnswers(detail, mode),
              if (detail.question.target?.explanation.isNotEmpty ?? false) ...[
                const SizedBox(height: 24),
                _buildExplanation(detail.question.target!.explanation),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswers(LearningSessionDetail detail, LearningMode mode) {
    final answers = detail.question.target?.answers ?? [];
    final selectedIds = detail.selectedAnswers.map((a) => a.id).toSet();
    final isPractice = mode == LearningMode.practice;

    return answers.map((answer) {
      bool isSelected = selectedIds.contains(answer.id);
      bool isCorrect = answer.isCorrect;

      Color bgColor = Colors.white;
      Color borderColor = Colors.grey.shade200;
      Widget? trailing;

      if (isPractice) {
        if (isCorrect) {
          bgColor = Colors.green.withValues(alpha: 0.08);
          borderColor = Colors.green.withValues(alpha: 0.3);
          trailing = const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          );
        }
      } else {
        if (isCorrect) {
          bgColor = Colors.green.withValues(alpha: 0.08);
          borderColor = Colors.green.withValues(alpha: 0.3);
          trailing = Icon(
            isSelected ? Icons.check_circle : Icons.check_circle_outline,
            color: Colors.green,
            size: 20,
          );
        } else if (isSelected) {
          bgColor = Colors.red.withValues(alpha: 0.08);
          borderColor = Colors.red.withValues(alpha: 0.3);
          trailing = const Icon(Icons.cancel, color: Colors.red, size: 20);
        }
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(answer.content, style: const TextStyle(fontSize: 15)),
            ),
            ?trailing,
          ],
        ),
      );
    }).toList();
  }

  Widget _buildExplanation(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
    );
  }
}
