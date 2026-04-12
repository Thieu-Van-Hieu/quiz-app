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
import 'package:frontend/features/learning/widgets/eos/answer_column.dart';
import 'package:frontend/features/learning/widgets/eos/bottom_bar.dart';
import 'package:frontend/features/learning/widgets/eos/clock.dart';
import 'package:frontend/features/learning/widgets/eos/feedback_column.dart';
import 'package:frontend/features/learning/widgets/eos/progress_row.dart';
import 'package:frontend/features/learning/widgets/eos/question_content_column.dart';
import 'package:frontend/features/learning/widgets/retro/button.dart';
import 'package:frontend/features/learning/widgets/retro/checkbox.dart';
import 'package:frontend/features/setting/constants/keymaps.dart';
import 'package:frontend/features/setting/enums/shortcut_action.dart';
import 'package:frontend/features/setting/notifiers/app_config_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExamPage extends HookConsumerWidget {
  final int sessionId;

  const ExamPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lấy dữ liệu cấu hình từ hệ thống
    final configAsync = ref.watch(watchAppConfigProvider);
    final sessionAsync = ref.watch(watchLearningSessionProvider(sessionId));
    final container = ProviderScope.containerOf(context);
    final focusNode = useFocusNode();

    return sessionAsync.when(
      loading: () =>
          const Material(child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Material(child: Center(child: Text("Lỗi: $err"))),
      data: (session) {
        if (session == null) {
          return const Material(
            child: Center(child: Text("Không tìm thấy phiên thi")),
          );
        }
        // Lấy config thực tế hoặc dùng object mặc định nếu đang load
        final config = configAsync.maybeWhen(
          data: (c) => c,
          orElse: () => null,
        );

        final elapsedSeconds = useState<int>(session.studyTime);
        final isConfirmedFinish = useState(false);
        final currentDetail = session.getCurrentLearningSessionDetail();

        if (currentDetail == null) return const SizedBox.shrink();

        // --- CORE LOGIC ---
        void performSave() {
          session.studyTime = elapsedSeconds.value;
          container
              .read(learningSessionProvider.notifier)
              .updateSession(session);
        }

        void jumpToPage(int newIndex) {
          if (newIndex >= 0 &&
              newIndex < session.learningSessionDetails.length) {
            performSave();
            session.currentIndex = newIndex;
            container
                .read(learningSessionProvider.notifier)
                .updateSession(session);
          }
        }

        Future<void> handleFinishExam() async {
          final details = session.learningSessionDetails;
          for (var detail in details) {
            await container
                .read(learningSessionDetailProvider(detail.id).notifier)
                .checkQuestion(detail.id);
          }

          int correct = details.where((d) => d.isCorrect == true).length;
          int wrong = details
              .where(
                (d) => d.selectedAnswers.isNotEmpty && d.isCorrect == false,
              )
              .length;

          session.isCompleted = true;
          session.endTime = DateTime.now();
          session.studyTime = elapsedSeconds.value;
          session.totalCorrect = correct;
          session.totalWrong = wrong;

          await container
              .read(learningSessionProvider.notifier)
              .updateSession(session);
          await container
              .read(learningSessionProvider.notifier)
              .completeSession(sessionId);
          container.invalidate(watchLearningSessionsProvider);

          if (context.mounted) {
            context.go(LearningRoutes.sessionPath(sessionId));
          }
        }

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

        // Helper để chọn đáp án nhanh bằng phím (A, B, C...)
        void handleQuickAnswer(LogicalKeyboardKey key) {
          if (!(config?.enableQuickAnswer ?? false)) return;

          final label = key.keyLabel.toUpperCase();
          if (label.length == 1 && label.contains(RegExp(r'[A-Z]'))) {
            final index = label.codeUnitAt(0) - 65; // A=0, B=1...
            final answers = currentDetail.question.target?.answers ?? [];
            if (index < answers.length) {
              container
                  .read(
                    learningSessionDetailProvider(currentDetail.id).notifier,
                  )
                  .toggleAnswer(currentDetail.id, answers[index]);
              ref.invalidate(watchLearningSessionProvider(sessionId));
            }
          }
        }

        // --- HANDLERS ---
        void handleInput(dynamic input) {
          if (isActionTriggered(ShortcutAction.nextQuestion, input)) {
            jumpToPage(session.currentIndex + 1);
          } else if (isActionTriggered(
            ShortcutAction.previousQuestion,
            input,
          )) {
            jumpToPage(session.currentIndex - 1);
          } else if (input is LogicalKeyboardKey) {
            handleQuickAnswer(input);
          }
        }

        // --- EFFECTS ---
        useEffect(() {
          focusNode.requestFocus();
          final timer = Timer.periodic(const Duration(seconds: 1), (t) {
            elapsedSeconds.value++;
            session.studyTime = elapsedSeconds.value;
          });
          return () => timer.cancel();
        }, [sessionId]);

        final (eosHeader, fontSize, fontFamily) = useEosHeader(
          ref: ref,
          info: LearningStrings.generateExamHeader(
            quizName: session.quiz.target?.name ?? "N/A",
            durationMinutes: session.timeLimit ?? 0,
          ),
          clockWidget: EosClock(
            initialSeconds:
                (session.timeLimit ?? 0) * 60 - elapsedSeconds.value,
            isCountDown: true,
            onFinished: handleFinishExam,
          ),
        );

        final (feedbackColWidth, feedbackColSplitter) = useEosResizable();
        const primaryBlue = Color(0xFF110CDD);

        return KeyboardListener(
          focusNode: focusNode,
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) handleInput(event.logicalKey);
          },
          child: Material(
            color: const Color(0xFFF0F0F0),
            child: Column(
              children: [
                eosHeader,
                EosProgressRow(
                  answeredCount: session.learningSessionDetails
                      .where((d) => d.selectedAnswers.isNotEmpty)
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
                        // MOUSE SHORTCUTS: Chỉ hoạt động trong vùng Answer Column
                        Listener(
                          behavior: HitTestBehavior.opaque,
                          onPointerDown: (event) {
                            focusNode.requestFocus();
                            handleInput(event.buttons);
                          },
                          child: SizedBox(
                            width: 130.0,
                            child: EosAnswerColumn(
                              learningSessionDetail: currentDetail,
                              onAnswerSelected: (answer) {
                                ref
                                    .read(
                                      learningSessionDetailProvider(
                                        currentDetail.id,
                                      ).notifier,
                                    )
                                    .toggleAnswer(currentDetail.id, answer);
                                ref.invalidate(
                                  watchLearningSessionProvider(sessionId),
                                );
                              },
                              actions: [
                                RetroButton(
                                  label: "Next",
                                  width: 85,
                                  onTap:
                                      session.currentIndex <
                                          session
                                                  .learningSessionDetails
                                                  .length -
                                              1
                                      ? () =>
                                            jumpToPage(session.currentIndex + 1)
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                RetroButton(
                                  label: "Back",
                                  width: 85,
                                  onTap: session.currentIndex > 0
                                      ? () =>
                                            jumpToPage(session.currentIndex - 1)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1, color: Colors.grey),
                        EosFeedbackColumn(
                          width: feedbackColWidth,
                          learningSessionDetail: currentDetail,
                        ),
                        feedbackColSplitter,
                        Expanded(
                          child: EosQuestionContent(
                            fontSize: fontSize,
                            fontFamily: fontFamily,
                            learningSessionDetail: currentDetail,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                EosBottomBar(
                  bgColor: const Color(0xFFD4D0C8),
                  leftActions: [
                    RetroCheckbox(
                      value: isConfirmedFinish.value,
                      onChanged: (v) => isConfirmedFinish.value = v ?? false,
                      label: 'I want to finish the exam.',
                    ),
                    const SizedBox(width: 10),
                    RetroButton(
                      label: "Finish",
                      color: isConfirmedFinish.value
                          ? const Color(0xFFFFF176)
                          : Colors.grey.shade400,
                      width: 80,
                      onTap: isConfirmedFinish.value ? handleFinishExam : null,
                    ),
                  ],
                  rightActions: [
                    RetroButton(
                      label: "Exit",
                      width: 80,
                      onTap: () {
                        performSave();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
