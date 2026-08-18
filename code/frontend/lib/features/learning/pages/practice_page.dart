import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/constants/learning_strings.dart';
import 'package:frontend/features/learning/hooks/eos/use_header.dart';
import 'package:frontend/features/learning/hooks/eos/use_resizable.dart';
import 'package:frontend/features/learning/notifiers/learning_session_detail_notifier.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/learning/utils/learning_flow_utils.dart';
import 'package:frontend/features/learning/widgets/eos/bottom_bar.dart';
import 'package:frontend/features/learning/widgets/eos/clock.dart';
import 'package:frontend/features/learning/widgets/eos/feedback_column.dart';
import 'package:frontend/features/learning/widgets/eos/progress_row.dart';
import 'package:frontend/features/learning/widgets/eos/question_content_column.dart';
import 'package:frontend/features/learning/widgets/retro/button.dart';
import 'package:frontend/features/setting/constants/keymaps.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:frontend/features/setting/notifiers/app_config_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PracticePage extends HookConsumerWidget {
  final int sessionId;

  const PracticePage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(watchAppConfigProvider);
    final sessionAsync = ref.watch(watchLearningSessionProvider(sessionId));
    final focusNode = useFocusNode();
    final container = ProviderScope.containerOf(context);

    return sessionAsync.when(
      loading: () =>
          const Material(child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Material(child: Center(child: Text("Lỗi: $err"))),
      data: (session) {
        if (session == null) {
          return const Material(
            child: Center(child: Text("Không tìm thấy session")),
          );
        }

        final config = configAsync.maybeWhen(
          data: (c) => c,
          orElse: () => null,
        );

        final currentIndex = useState<int>(session.currentIndex);
        final elapsedSeconds = useState<int>(session.studyTime);
        final isShowingAnswer = useState<bool>(false);
        final isFinishingRef = useRef(false);

        // Biến trigger ép Rebuild UI khi đánh dấu câu mà không chuyển trang
        final refreshState = useState<int>(0);

        final flowUtils = useMemoized(
          () => LearningFlowUtils(reviewOffset: session.reviewOffset),
          [session.reviewOffset],
        );

        useEffect(() {
          if (currentIndex.value >= session.learningSessionDetails.length) {
            currentIndex.value = 0;
          }
          return null;
        }, [session.learningSessionDetails.length]);

        // --- SHORTCUT MAPPER ---
        bool isActionTriggered(ShortcutAction action, dynamic input) {
          if (config == null) return false;
          final bindings = config.keyBindings[action] ?? [];

          return bindings.any((physicalKey) {
            if (input is LogicalKeyboardKey) {
              return KeyMaps.logicalToPhysical[input] == physicalKey;
            }
            if (input is int) {
              return KeyMaps.mouseButtonsMap[input] == physicalKey;
            }
            return false;
          });
        }

        // --- CORE LOGIC ---
        Future<void> performSave({
          bool isCompleted = false,
          int? overrideIndex,
        }) async {
          if (isFinishingRef.value && !isCompleted) return;

          session.studyTime = elapsedSeconds.value;
          session.currentIndex = overrideIndex ?? currentIndex.value;
          session.isCompleted = isCompleted;
          if (isCompleted) session.endTime = DateTime.now();

          await container
              .read(learningSessionProvider.notifier)
              .updateSession(session);
        }

        void jumpToPage(int newIndex) {
          final details = session.learningSessionDetails;
          if (newIndex >= 0 && newIndex < details.length) {
            currentIndex.value = newIndex;
            performSave(overrideIndex: newIndex);
          }
        }

        Future<void> markCurrentAndNext({required bool isPassed}) async {
          final details = session.learningSessionDetails;
          final currIdx = currentIndex.value;

          if (currIdx < 0 || currIdx >= details.length) return;

          final targetDetail = details[currIdx];
          targetDetail.isPassed = isPassed;

          if (isPassed) {
            await container
                .read(learningSessionDetailProvider.notifier)
                .markAsPass(targetDetail.id);
          } else {
            await container
                .read(learningSessionDetailProvider.notifier)
                .markAsNotPass(targetDetail.id);
          }

          final nextIndex = flowUtils.getNextIndex(
            details: details,
            currentIndex: currIdx,
          );

          // Nếu nextIndex trả về khác câu hiện tại thì mới nhảy trang
          if (nextIndex != -1 && nextIndex != currIdx) {
            jumpToPage(nextIndex);
          } else {
            // Nếu vẫn là câu cũ (hoặc -1), ép rebuild UI để cập nhật lại Feedback UI
            refreshState.value++;
            performSave();
          }
        }

        void toggleShowAnswer() {
          final details = session.learningSessionDetails;
          if (currentIndex.value < 0 || currentIndex.value >= details.length) {
            return;
          }

          final currentDetail = details[currentIndex.value];

          isShowingAnswer.value = !isShowingAnswer.value;
          container
              .read(learningSessionDetailProvider.notifier)
              .markAsPass(currentDetail.id);
          debugPrint(
            "[PracticePage] Toggled show answer for detailId: ${currentDetail.id}, isShowingAnswer: ${isShowingAnswer.value}, isChecked: ${currentDetail.isChecked}, isPassed: ${currentDetail.isPassed}",
          );
        }

        // --- HANDLERS ---
        void handleShortcut(dynamic input) {
          if (isActionTriggered(ShortcutAction.toggleQuestion, input)) {
            toggleShowAnswer();
          } else if (isActionTriggered(ShortcutAction.nextQuestion, input)) {
            markCurrentAndNext(isPassed: true);
          } else if (isActionTriggered(
            ShortcutAction.previousQuestion,
            input,
          )) {
            if (currentIndex.value > 0) jumpToPage(currentIndex.value - 1);
          }
        }

        useEffect(() {
          final details = session.learningSessionDetails;
          if (currentIndex.value >= 0 && currentIndex.value < details.length) {
            final detail = details[currentIndex.value];
            isShowingAnswer.value = detail.isPassed != true;
          }
          return null;
        }, [currentIndex.value]);

        useEffect(() {
          focusNode.requestFocus();
          final timer = Timer.periodic(const Duration(seconds: 1), (t) {
            elapsedSeconds.value++;
          });
          return () {
            timer.cancel();
            if (!isFinishingRef.value) performSave();
          };
        }, []);

        final details = session.learningSessionDetails;
        final safeIndex = currentIndex.value.clamp(
          0,
          details.isEmpty ? 0 : details.length - 1,
        );
        final currentDetail = details.isNotEmpty ? details[safeIndex] : null;

        if (currentDetail == null) {
          return const Material(
            child: Center(child: Text("Không có dữ liệu câu hỏi")),
          );
        }

        final (eosHeader, fontSize, fontFamily) = useEosHeader(
          ref: ref,
          info: LearningStrings.generateStudyHeader(
            quizName: session.quiz.target?.name ?? "N/A",
          ),
          clockWidget: EosClock(
            initialSeconds: elapsedSeconds.value,
            isCountDown: false,
          ),
        );
        final (feedbackColumnWidth, eosVerticalSplitter) = useEosResizable();

        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop && !isFinishingRef.value) performSave();
          },
          child: Material(
            color: const Color(0xFFF0F0F0),
            child: KeyboardListener(
              focusNode: focusNode,
              autofocus: true,
              onKeyEvent: (event) {
                if (event is KeyDownEvent) handleShortcut(event.logicalKey);
              },
              child: Column(
                children: [
                  eosHeader,
                  EosProgressRow(
                    answeredCount: session.learningSessionDetails
                        .where(
                          (d) => (session.reviewOffset > 0
                              ? d.isPassed == true
                              : d.isPassed != null),
                        )
                        .length,
                    totalQuestions: session.learningSessionDetails.length,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          EosFeedbackColumn(
                            width: feedbackColumnWidth,
                            learningSessionDetail: currentDetail,
                          ),
                          eosVerticalSplitter,
                          Expanded(
                            child: GestureDetector(
                              onTap: () => focusNode.requestFocus(),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: currentDetail.isPassed == false
                                          ? Colors.amber.shade50
                                          : null,
                                      border: currentDetail.isPassed == false
                                          ? Border.all(
                                              color: Colors.orange.shade800,
                                              width: 2.5,
                                            )
                                          : null,
                                    ),
                                    child: EosQuestionContent(
                                      fontSize: fontSize,
                                      fontFamily: fontFamily,
                                      learningSessionDetail: currentDetail,
                                      showAnswer: isShowingAnswer.value,
                                    ),
                                  ),
                                  if (currentDetail.isPassed == false)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade800,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.replay_rounded,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'CÂU LÀM LẠI',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  EosBottomBar(
                    bgColor: const Color(0xFFD4D0C8),
                    rightActions: [
                      if (session.reviewOffset <= 0) ...[
                        RetroButton(
                          label: "<< Back",
                          width: 85,
                          onTap: currentIndex.value > 0
                              ? () => jumpToPage(currentIndex.value - 1)
                              : null,
                        ),
                        const SizedBox(width: 8),
                      ],
                      RetroButton(
                        label: "Mark as Not Pass",
                        width: 140,
                        color: Colors.red.shade100,
                        onTap:
                            (flowUtils.peekNextIndex(
                                  details: details,
                                  currentIndex: currentIndex.value,
                                ) ==
                                -1)
                            ? null
                            : () => markCurrentAndNext(isPassed: false),
                      ),
                      const SizedBox(width: 8),
                      RetroButton(
                        label: isShowingAnswer.value ? "Hide" : "Show",
                        width: 85,
                        onTap: toggleShowAnswer,
                      ),
                      const SizedBox(width: 8),
                      RetroButton(
                        label: "Next >>",
                        width: 85,
                        onTap:
                            (flowUtils.peekNextIndex(
                                  details: details,
                                  currentIndex: currentIndex.value,
                                ) ==
                                -1)
                            ? null
                            : () => markCurrentAndNext(isPassed: true),
                      ),
                      const SizedBox(width: 16),
                      RetroButton(
                        label: "Complete",
                        width: 85,
                        color: Colors.green.shade100,
                        onTap: () async {
                          isFinishingRef.value = true;
                          await performSave(isCompleted: true);
                          await container
                              .read(learningSessionProvider.notifier)
                              .completeSession(sessionId);
                          if (context.mounted) {
                            context.go(LearningRoutes.sessionPath(sessionId));
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
