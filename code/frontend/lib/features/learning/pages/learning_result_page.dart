import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/input/search_bar.dart';
import 'package:frontend/core/widgets/layout/pagination.dart';
import 'package:frontend/features/learning/models/learning_setting.dart';
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/learning/widgets/learning_result/learning_result_card.dart';
import 'package:frontend/features/learning/widgets/learning_setting_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LearningResultPage extends HookConsumerWidget {
  const LearningResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Khởi tạo Params
    final searchParamsNotifier = useState(
      LearningSessionSearchParams(page: 0, size: 10),
    );

    // 2. Watch dữ liệu
    final sessionsAsync = ref.watch(
      watchLearningSessionsProvider(searchParamsNotifier.value),
    );

    final totalPagesAsync = ref.watch(
      watchLearningSessionTotalPagesProvider(searchParamsNotifier.value),
    );

    useEffect(() {
      void _ = ref.refresh(
        watchLearningSessionsProvider(searchParamsNotifier.value),
      );
      return null;
    }, []);

    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              "Lịch sử học tập",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1C1E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Xem lại và rèn luyện những nội dung bạn đã học",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // SEARCH BAR
            AppSearchBar(
              onSearch: (v) => searchParamsNotifier.value = searchParamsNotifier
                  .value
                  .copyWith(keyword: v, page: 0),
            ),
            const SizedBox(height: 32),

            // NỘI DUNG CHÍNH (GRID VIEW)
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return const Center(
                      child: Text("Không tìm thấy dữ liệu học tập nào."),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 350,
                                mainAxisExtent: 450,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                              ),
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            final int quizId = session.quiz.target?.id ?? 0;
                            final details = session.learningSessionDetails;
                            final quiz = session.quiz.target;
                            int startIndex = 0;
                            int endIndex = 0;
                            final List<int> allQuestionIdsInQuiz =
                                quiz?.questions.map((q) => q.id).toList() ?? [];

                            if (details.isNotEmpty &&
                                allQuestionIdsInQuiz.isNotEmpty) {
                              final List<int> currentSessionIndices = details
                                  .map((d) {
                                    final qId = d.question.target?.id ?? 0;
                                    final idx = allQuestionIdsInQuiz.indexOf(
                                      qId,
                                    );
                                    return idx != -1 ? idx + 1 : -1;
                                  })
                                  .where((stt) => stt > 0)
                                  .toList();

                              if (currentSessionIndices.isNotEmpty) {
                                currentSessionIndices.sort();
                                startIndex = currentSessionIndices.first;
                                endIndex = currentSessionIndices.last;
                              }
                            }

                            return LearningResultCard(
                              key: ValueKey(
                                '${session.id}_${session.isCompleted}',
                              ),
                              session: session,
                              onTap: () => context.go(
                                LearningRoutes.sessionPath(session.id),
                              ),
                              onRetake: () =>
                                  _handleRetake(context, ref, session.id),
                              onCreateMistakeSession: session.endTime != null
                                  ? () => _handleMistakePractice(
                                      context,
                                      ref,
                                      session.id,
                                    )
                                  : null,
                              onConfigureRetake: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => LearningSettingDialog(
                                    totalQuestions: quiz?.questions.length ?? 0,
                                    initialSetting: LearningSetting(
                                      fromIndex: startIndex - 1,
                                      toIndex: endIndex - 1,
                                      shuffleQuestions:
                                          session.shuffleQuestions,
                                      shuffleOptions: session.shuffleAnswers,
                                      learningMode: session.learningModeEnum,
                                      customTimeLimit: session.timeLimit,
                                    ),
                                    onConfirm: (newSetting) =>
                                        _handleConfigureRetake(
                                          context,
                                          ref,
                                          quizId,
                                          newSetting,
                                        ),
                                  ),
                                );
                              },
                              onDelete: () => _handleDelete(
                                context,
                                ref,
                                session,
                                sessions,
                                searchParamsNotifier,
                              ),
                            );
                          },
                        ),
                      ),

                      // PHÂN TRANG (PAGINATION)
                      const SizedBox(height: 24),
                      totalPagesAsync.maybeWhen(
                        data: (total) => AppPagination(
                          currentPage: searchParamsNotifier.value.page,
                          totalPages: total,
                          onPageChange: (newPage) {
                            searchParamsNotifier.value = searchParamsNotifier
                                .value
                                .copyWith(page: newPage);
                          },
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Lỗi: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC XỬ LÝ ---

  // Hàm tạo session cấu hình lại và nhảy trang trực tiếp (Style chuẩn giống QuizPage)
  Future<void> _handleConfigureRetake(
    BuildContext context,
    WidgetRef ref,
    int quizId,
    LearningSetting settings,
  ) async {
    final sessionNotifier = ref.read(learningSessionProvider.notifier);
    try {
      final newSession = await sessionNotifier.createSession(
        quizId: quizId,
        setting: settings,
      );
      if (context.mounted) {
        // GoRouter tự giải phóng cây widget cũ cùng Dialog, không sinh lỗi lock
        context.go(LearningRoutes.sessionPath(newSession.id));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    }
  }

  Future<void> _handleRetake(
    BuildContext context,
    WidgetRef ref,
    int oldId,
  ) async {
    final notifier = ref.read(learningSessionProvider.notifier);
    try {
      final newSession = await notifier.retakeSession(oldId).withToast(context);
      if (context.mounted && newSession != null) {
        context.go(LearningRoutes.sessionPath(newSession.id));
      }
    } catch (e) {
      debugPrint("Lỗi Retake: $e");
    }
  }

  Future<void> _handleMistakePractice(
    BuildContext context,
    WidgetRef ref,
    int oldId,
  ) async {
    final notifier = ref.read(learningSessionProvider.notifier);
    try {
      final newSession = await notifier
          .createMistakeSession(oldId)
          .withToast(context);
      if (context.mounted && newSession != null) {
        context.go(LearningRoutes.sessionPath(newSession.id));
      }
    } catch (e) {
      debugPrint("Lỗi Mistake Practice: $e");
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    LearningSession session,
    List<LearningSession> currentSessions,
    ValueNotifier<LearningSessionSearchParams> paramsNotifier,
  ) async {
    String itemName = "Phiên học";
    final quiz = session.quiz.target;
    if (quiz != null) {
      final subject = quiz.subject.target;
      itemName = subject != null ? "${subject.name} - ${quiz.name}" : quiz.name;
    }

    final sessionId = session.id;

    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmDialog(
        itemName: itemName,
        onDelete: () async {
          await ref
              .read(learningSessionProvider.notifier)
              .deleteSession(sessionId)
              .withToast(context);

          if (currentSessions.length == 1 && paramsNotifier.value.page > 0) {
            paramsNotifier.value = paramsNotifier.value.copyWith(
              page: paramsNotifier.value.page - 1,
            );
          }
        },
      ),
    );
  }
}
