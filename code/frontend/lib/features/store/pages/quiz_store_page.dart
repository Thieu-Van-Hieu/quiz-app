import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/input/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/data/subject_repository.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/widgets/quiz/duplicate_confirm_dialog.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:frontend/features/store/notifiers/quiz_store_notifier.dart';
import 'package:frontend/features/store/services/github_quiz_source.dart';
import 'package:frontend/features/store/widgets/import_remote_dialog.dart';
import 'package:frontend/features/store/widgets/remote_quiz_card.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum _StoreFilter {
  all('Tất cả'),
  notImported('Chưa import'),
  outdated('Có bản mới');

  final String label;

  const _StoreFilter(this.label);
}

enum _StoreSort {
  updated('Mới cập nhật'),
  name('Tên A-Z');

  final String label;

  const _StoreSort(this.label);
}

/// Trang "Kho đề": danh sách bộ đề có sẵn trên GitHub, tải & import 1 nút
class QuizStorePage extends HookConsumerWidget {
  const QuizStorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeAsync = ref.watch(quizStoreProvider);
    final keyword = useState('');
    final filter = useState(_StoreFilter.all);
    final sort = useState(_StoreSort.updated);
    final busyPath = useState<String?>(null);

    Future<void> handleImport(RemoteQuiz remote, ImportStatus status) async {
      busyPath.value = remote.path;
      try {
        final notifier = ref.read(quizStoreProvider.notifier);
        final quiz = await notifier.download(remote);
        final subjects = await ref
            .read(subjectRepositoryProvider)
            .watchAllSubjects()
            .first;
        if (!context.mounted) return;
        busyPath.value = null;

        final resolved = await DuplicateConfirmDialog.resolve(context, quiz);
        if (resolved == null || !context.mounted) return;

        // Bản cập nhật thường trùng tên với bản đã import → gợi ý tên mới
        final initialName = status == ImportStatus.notImported
            ? resolved.name
            : '${resolved.name} (${DateFormat('dd-MM-yyyy').format(remote.lastUpdated?.toLocal() ?? DateTime.now())})';

        int? savedSubjectId;
        final saved = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => ImportRemoteDialog(
            subjectCode: remote.subjectCode,
            initialName: initialName,
            questionCount: resolved.questions.length,
            subjects: subjects,
            onSubmit: ({subjectId, newSubjectCode, required quizName}) async {
              resolved.name = quizName;
              savedSubjectId = await notifier.saveImported(
                remote: remote,
                quiz: resolved,
                subjectId: subjectId,
                newSubjectCode: newSubjectCode,
              );
            },
          ),
        );

        if (saved == true && context.mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text('Đã import "${resolved.name}"'),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
                action: savedSubjectId == null
                    ? null
                    : SnackBarAction(
                        label: 'MỞ MÔN HỌC',
                        textColor: Colors.white,
                        onPressed: () => context.go(
                          LibraryRoutes.getSubjectDetailPath(savedSubjectId!),
                        ),
                      ),
              ),
            );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  e is RemoteSourceException ? e.message : 'Lỗi import: $e',
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      } finally {
        if (context.mounted) busyPath.value = null;
      }
    }

    return Material(
      color: LibraryColors.background,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Kho đề",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: LibraryColors.primaryText,
                        ),
                      ),
                      Text(
                        "Bộ đề có sẵn trên GitHub — tải và import chỉ với 1 nút",
                        style: TextStyle(color: LibraryColors.secondaryText),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  label: "Mở GitHub",
                  icon: Icons.open_in_new_rounded,
                  variant: ButtonVariant.slateOutlined,
                  size: ButtonSize.small,
                  onPressed: () => launchUrl(Uri.parse(AppStrings.quizJsonUrl)),
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: "Làm mới",
                  icon: Icons.refresh_rounded,
                  variant: ButtonVariant.slate,
                  size: ButtonSize.small,
                  isLoading: storeAsync.isLoading,
                  onPressed: storeAsync.isLoading
                      ? null
                      : () => ref.read(quizStoreProvider.notifier).refresh(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppSearchBar(
                    hintText: "Tìm theo tên bộ đề hoặc mã môn...",
                    onSearch: (v) => keyword.value = v,
                  ),
                ),
                const SizedBox(width: 16),
                for (final f in _StoreFilter.values) ...[
                  ChoiceChip(
                    label: Text(f.label),
                    selected: filter.value == f,
                    selectedColor: AppColors.brand,
                    onSelected: (_) => filter.value = f,
                  ),
                  const SizedBox(width: 8),
                ],
                const SizedBox(width: 8),
                DropdownButton<_StoreSort>(
                  value: sort.value,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    for (final s in _StoreSort.values)
                      DropdownMenuItem(value: s, child: Text(s.label)),
                  ],
                  onChanged: (v) => sort.value = v ?? sort.value,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: storeAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text("Đang lấy danh sách bộ đề từ GitHub..."),
                    ],
                  ),
                ),
                error: (err, _) => _ErrorView(
                  message: err is RemoteSourceException
                      ? err.message
                      : "${AppStrings.error}: $err",
                  onRetry: () => ref.read(quizStoreProvider.notifier).refresh(),
                ),
                data: (data) {
                  final matcher = TextMatcher(keyword.value);
                  final quizzes =
                      matcher
                          .filter(data.quizzes, (q) => [q.title, q.subjectCode])
                          .where(
                            (q) => switch (filter.value) {
                              _StoreFilter.all => true,
                              _StoreFilter.notImported =>
                                data.statusOf(q) == ImportStatus.notImported,
                              _StoreFilter.outdated =>
                                data.statusOf(q) == ImportStatus.outdated,
                            },
                          )
                          .toList()
                        ..sort(
                          (a, b) => switch (sort.value) {
                            _StoreSort.name => a.title.toLowerCase().compareTo(
                              b.title.toLowerCase(),
                            ),
                            _StoreSort.updated =>
                              (b.lastUpdated ?? DateTime(0)).compareTo(
                                a.lastUpdated ?? DateTime(0),
                              ),
                          },
                        );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.warning != null) _WarningBanner(data.warning!),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "${quizzes.length} / ${data.quizzes.length} bộ đề",
                          style: const TextStyle(
                            color: LibraryColors.secondaryText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: quizzes.isEmpty
                            ? const Center(child: Text(AppStrings.noData))
                            : ListView.separated(
                                itemCount: quizzes.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final q = quizzes[index];
                                  final status = data.statusOf(q);
                                  return RemoteQuizCard(
                                    quiz: q,
                                    status: status,
                                    isBusy: busyPath.value == q.path,
                                    onImport: busyPath.value == null
                                        ? () => handleImport(q, status)
                                        : null,
                                    onOpenGithub: () =>
                                        launchUrl(Uri.parse(q.htmlUrl)),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String message;

  const _WarningBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.toastWarning.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.toastWarning),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: LibraryColors.secondaryText,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          AppButton(
            label: "Thử lại",
            icon: Icons.refresh_rounded,
            variant: ButtonVariant.slate,
            size: ButtonSize.small,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
