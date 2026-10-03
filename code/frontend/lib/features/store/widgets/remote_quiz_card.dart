import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/widgets/button/action_button.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:intl/intl.dart';

class RemoteQuizCard extends StatelessWidget {
  final RemoteQuiz quiz;
  final ImportStatus status;
  final bool isBusy;
  final VoidCallback? onImport;
  final VoidCallback onOpenGithub;

  const RemoteQuizCard({
    super.key,
    required this.quiz,
    required this.status,
    required this.isBusy,
    required this.onImport,
    required this.onOpenGithub,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final freshness = QuizFreshness.of(quiz.lastUpdated, now);
    final updated = quiz.lastUpdated;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: LibraryColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == ImportStatus.outdated
              ? AppColors.indigoShadow
              : LibraryColors.divider,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: LibraryColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LibraryColors.quizHighlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: AppColors.brandShadow,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LibraryColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Badge(
                      label: quiz.subjectCode,
                      color: AppColors.slate,
                      icon: Icons.folder_rounded,
                    ),
                    _Badge(
                      label: freshness.label,
                      color: _freshnessColor(freshness),
                      icon: _freshnessIcon(freshness),
                    ),
                    if (status != ImportStatus.notImported)
                      _Badge(
                        label: status == ImportStatus.outdated
                            ? 'Có bản mới'
                            : 'Đã import',
                        color: status == ImportStatus.outdated
                            ? AppColors.indigoShadow
                            : AppColors.brandShadow,
                        icon: status == ImportStatus.outdated
                            ? Icons.upgrade_rounded
                            : Icons.check_circle_rounded,
                      ),
                    Text(
                      [
                        if (updated != null)
                          'Cập nhật ${relativeTime(updated, now)} (${DateFormat('dd/MM/yyyy').format(updated.toLocal())})',
                        _formatSize(quiz.size),
                      ].join('  ·  '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: LibraryColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          AppActionButton(
            icon: Icons.open_in_new_rounded,
            tooltip: 'Xem trên GitHub',
            actionType: ActionType.info,
            onTap: onOpenGithub,
          ),
          const SizedBox(width: 12),
          // Chỉ đặt bề rộng tối thiểu cho thẳng hàng; bề rộng cố định làm
          // tràn chữ khi đổi nhãn ("Tải & import" / "Đang xử lý...")
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: AppButton(
              label: switch (status) {
                ImportStatus.notImported => 'Tải & import',
                ImportStatus.outdated => 'Cập nhật',
                ImportStatus.upToDate => 'Import lại',
              },
              icon: Icons.download_rounded,
              variant: switch (status) {
                ImportStatus.notImported => ButtonVariant.brand,
                ImportStatus.outdated => ButtonVariant.indigo,
                ImportStatus.upToDate => ButtonVariant.slateOutlined,
              },
              size: ButtonSize.small,
              isLoading: isBusy,
              onPressed: onImport,
            ),
          ),
        ],
      ),
    );
  }

  static Color _freshnessColor(QuizFreshness f) => switch (f) {
    QuizFreshness.fresh => AppColors.brandShadow,
    QuizFreshness.recent => AppColors.indigoShadow,
    QuizFreshness.normal => AppColors.slateShadow,
    QuizFreshness.stale => AppColors.orangeShadow,
    QuizFreshness.unknown => AppColors.slate,
  };

  static IconData _freshnessIcon(QuizFreshness f) => switch (f) {
    QuizFreshness.fresh => Icons.fiber_new_rounded,
    QuizFreshness.recent => Icons.update_rounded,
    QuizFreshness.normal => Icons.schedule_rounded,
    QuizFreshness.stale => Icons.hourglass_bottom_rounded,
    QuizFreshness.unknown => Icons.help_outline_rounded,
  };

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _Badge({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMain),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
