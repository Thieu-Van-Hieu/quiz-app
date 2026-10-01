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
import 'package:frontend/features/learning/utils/learning_utils.dart';
import 'package:frontend/features/learning/widgets/eos/answer_column.dart';
import 'package:frontend/features/learning/widgets/eos/bottom_bar.dart';
import 'package:frontend/features/learning/widgets/eos/clock.dart';
import 'package:frontend/features/learning/widgets/eos/feedback_column.dart';
import 'package:frontend/features/learning/widgets/eos/progress_row.dart';
import 'package:frontend/features/learning/widgets/eos/question_content_column.dart';
import 'package:frontend/features/learning/widgets/retro/button.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/setting/constants/keymaps.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:frontend/features/setting/notifiers/app_config_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StudyPage extends HookConsumerWidget {
  final int sessionId;

  const StudyPage({super.key, required this.sessionId});

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
            child: Center(child: Text("Session not found")),
          );
        }

        final config = configAsync.maybeWhen(
          data: (c) => c,
          orElse: () => null,
        );

        final currentIndex = useState<int>(session.currentIndex);
        final elapsedSeconds = useState<int>(session.studyTime);
        final isFinishingRef = useRef(false);

        final flowUtils = useMemoized(
          () => LearningFlowUtils(reviewOffset: session.reviewOffset),
          [session.id, session.reviewOffset],
        );

        final currentIndexRef = useRef(currentIndex.value);
        currentIndexRef.value = currentIndex.value;

        final elapsedSecondsRef = useRef(elapsedSeconds.value);
        elapsedSecondsRef.value = elapsedSeconds.value;

        useEffect(() {
          if (currentIndex.value >= session.learningSessionDetails.length) {
            currentIndex.value = 0;
          }
          return null;
        }, [session.learningSessionDetails.length]);

        // --- CORE LOGIC ---
        Future<void> performSave({
          bool isCompleted = false,
          int? overrideIndex,
        }) async {
          if (isFinishingRef.value && !isCompleted) return;

          session.studyTime = elapsedSecondsRef.value;
          session.currentIndex = overrideIndex ?? currentIndexRef.value;
          session.isCompleted = isCompleted;
          if (isCompleted) session.endTime = DateTime.now();

          await container
              .read(learningSessionProvider.notifier)
              .updateSession(session);
        }

        Future<void> jumpToNextQuestion(int nextIndex) async {
          final details = session.learningSessionDetails;
          if (nextIndex >= 0 && nextIndex < details.length) {
            if (session.reviewOffset > 0 &&
                details[nextIndex].isPassed == false) {
              final targetDetail = details[nextIndex];

              // 1. Cập nhật trực tiếp trên memory để UI render câu mới mượt mà lập tức
              targetDetail.isChecked = false;
              targetDetail.isPassed = false;
              targetDetail.selectedAnswers.clear();

              // 2. Chuyển UI sang câu mới ngay lập tức
              currentIndex.value = nextIndex;

              // 3. Thực hiện lưu DB bất đồng bộ (không await để tránh block UI)
              container
                  .read(learningSessionDetailProvider.notifier)
                  .resetDetailForRetry(targetDetail.id);
            } else {
              currentIndex.value = nextIndex;
            }

            await performSave(overrideIndex: nextIndex);
          }
        }

        void jumpToPage(int newIndex) {
          final details = session.learningSessionDetails;
          if (newIndex >= 0 && newIndex < details.length) {
            currentIndex.value = newIndex;
            performSave(overrideIndex: newIndex);
          }
        }

        Future<void> handleFinishExam() async {
          isFinishingRef.value = true;
          await performSave(isCompleted: true);
          await container
              .read(learningSessionProvider.notifier)
              .completeSession(sessionId);
          if (context.mounted) {
            context.go(LearningRoutes.sessionPath(sessionId));
          }
        }

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

        if (currentDetail.learningSession.target == null) {
          currentDetail.learningSession.target = session;
        }

        final nextCalculatedIndex = flowUtils.peekNextIndex(
          details: details,
          currentIndex: safeIndex,
        );

        final isLastQuestion = nextCalculatedIndex == -1;

        final isCurrentRetryNotifier = useState<bool>(false);
        useEffect(() {
          // Khi mới chuyển sang câu hỏi này: nếu nó đang isPassed == false thì đánh dấu là câu làm lại
          isCurrentRetryNotifier.value =
              currentDetail.isPassed == false && session.reviewOffset > 0;

          return null;
        }, [currentDetail.id]);

        Future<void> handleCheckAction() async {
          if (currentDetail.isChecked) {
            final nextIndex = flowUtils.getNextIndex(
              details: details,
              currentIndex: safeIndex,
            );

            if (nextIndex == -1) {
              await handleFinishExam();
            } else {
              await jumpToNextQuestion(nextIndex);
            }
          } else {
            await container
                .read(learningSessionDetailProvider.notifier)
                .checkQuestion(currentDetail.id);
            await performSave();
          }
        }

        // Đánh dấu sai câu hiện tại thông qua Notifier
        Future<void> handleMarkAsNotPass() async {
          // 1. Cập nhật câu hiện tại: isChecked = false & isPassed = false thông qua Notifier
          currentDetail.isChecked = session.reviewOffset <= 0;
          currentDetail.isPassed = false;
          currentDetail.selectedAnswers.clear();
          await container
              .read(learningSessionDetailProvider.notifier)
              .markAsNotPass(currentDetail.id);

          // 2. Lấy câu tiếp theo từ FlowUtils
          final nextIndex = flowUtils.getNextIndex(
            details: details,
            currentIndex: safeIndex,
          );

          await performSave();

          // 3. Điều hướng sang câu kế tiếp hoặc hoàn thành
          if (nextIndex == -1) {
            await handleFinishExam();
          } else {
            await jumpToNextQuestion(nextIndex);
          }
        }

        // Đánh dấu đúng câu hiện tại (ghi đè kết quả kiểm tra) rồi sang câu tiếp theo
        Future<void> handleMarkAsPass() async {
          final detailNotifier = container.read(
            learningSessionDetailProvider.notifier,
          );
          if (!currentDetail.isChecked) {
            await detailNotifier.checkQuestion(currentDetail.id);
          }
          currentDetail.isChecked = true;
          currentDetail.isPassed = true;
          await detailNotifier.markAsPass(currentDetail.id);

          final nextIndex = flowUtils.getNextIndex(
            details: details,
            currentIndex: safeIndex,
          );

          await performSave();

          if (nextIndex == -1) {
            await handleFinishExam();
          } else {
            await jumpToNextQuestion(nextIndex);
          }
        }

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

        void handleQuickAnswer(LogicalKeyboardKey key) {
          if (!(config?.enableQuickAnswer ?? false) ||
              currentDetail.isChecked) {
            return;
          }

          final label = key.keyLabel.toUpperCase();
          if (label.length == 1 && label.contains(RegExp(r'[A-Z]'))) {
            final index = label.codeUnitAt(0) - 65;

            final originalAnswers =
                currentDetail.question.target?.answers ?? List<Answer>.empty();

            final shuffledAnswers = LearningUtils.getShuffledAnswers(
              session: session,
              questionId: currentDetail.question.target?.id ?? 0,
              originalAnswers: originalAnswers,
            );

            if (index < shuffledAnswers.length) {
              container
                  .read(learningSessionDetailProvider.notifier)
                  .toggleAnswer(currentDetail.id, shuffledAnswers[index]);
            }
          }
        }

        void handleInput(dynamic input) {
          debugPrint(input.toString());
          if (isActionTriggered(ShortcutAction.checkQuestion, input)) {
            handleCheckAction();
          } else if (isActionTriggered(ShortcutAction.nextQuestion, input)) {
            if (!isLastQuestion && currentDetail.isChecked) {
              handleCheckAction();
            }
          } else if (isActionTriggered(
            ShortcutAction.previousQuestion,
            input,
          )) {
            if (session.reviewOffset <= 0 && safeIndex > 0) {
              jumpToPage(safeIndex - 1);
            }
          } else if (input is LogicalKeyboardKey) {
            handleQuickAnswer(input);
          }
        }

        // --- EFFECTS ---
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
                if (event is KeyDownEvent) handleInput(event.logicalKey);
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
                          Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerDown: (event) {
                              focusNode.requestFocus();
                              handleInput(event.buttons);
                            },
                            child: SizedBox(
                              width: 140.0,
                              child: EosAnswerColumn(
                                learningSessionDetail: currentDetail,
                                onAnswerSelected: (answer) {
                                  if (currentDetail.isChecked) return;
                                  ref
                                      .read(
                                        learningSessionDetailProvider.notifier,
                                      )
                                      .toggleAnswer(currentDetail.id, answer);
                                },
                                actions: [
                                  RetroButton(
                                    label: currentDetail.isChecked
                                        ? (isLastQuestion
                                              ? "Finish"
                                              : "Next >>")
                                        : "Check",
                                    width: 110,
                                    color: currentDetail.isChecked
                                        ? (isLastQuestion
                                              ? Colors.green.shade100
                                              : null)
                                        : null,
                                    onTap: handleCheckAction,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                      color: isCurrentRetryNotifier.value
                                          ? Colors.amber.shade50
                                          : null,
                                      border: isCurrentRetryNotifier.value
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
                                      showAnswer: currentDetail.isChecked,
                                    ),
                                  ),
                                  if (isCurrentRetryNotifier.value)
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
                          onTap: safeIndex > 0
                              ? () => jumpToPage(safeIndex - 1)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        RetroButton(
                          label: "Next >>",
                          width: 85,
                          onTap: !isLastQuestion
                              ? () => handleCheckAction()
                              : null,
                        ),
                        const SizedBox(width: 8),
                      ],
                      RetroButton(
                        label: "Mark as Not Pass",
                        width: 130,
                        color: Colors.red.shade100,
                        onTap: handleMarkAsNotPass,
                      ),
                      const SizedBox(width: 8),
                      RetroButton(
                        label: "Mark as Pass",
                        width: 110,
                        color: Colors.lightGreen.shade100,
                        onTap: handleMarkAsPass,
                      ),
                      const SizedBox(width: 16),
                      RetroButton(
                        label: "Complete",
                        width: 85,
                        color: Colors.green.shade100,
                        onTap: handleFinishExam,
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
