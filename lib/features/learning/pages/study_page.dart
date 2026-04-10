import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';
import 'package:frontend/features/learning/constants/learning_strings.dart';
import 'package:frontend/features/learning/hooks/eos/use_header.dart';
import 'package:frontend/features/learning/hooks/eos/use_resizable.dart';
import 'package:frontend/features/learning/notifiers/learning_session_detail_notifier.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/widgets/eos/answer_column.dart';
import 'package:frontend/features/learning/widgets/eos/bottom_bar.dart';
import 'package:frontend/features/learning/widgets/eos/clock.dart';
import 'package:frontend/features/learning/widgets/eos/feedback_column.dart';
import 'package:frontend/features/learning/widgets/eos/progress_row.dart';
import 'package:frontend/features/learning/widgets/eos/question_content_column.dart';
import 'package:frontend/features/learning/widgets/retro/button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StudyShortcuts {
  static const List<dynamic> checkActions = [
    kSecondaryMouseButton,
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.enter,
  ];
  static const List<dynamic> nextActions = [
    kPrimaryMouseButton,
    kForwardMouseButton,
    LogicalKeyboardKey.arrowRight,
  ];
  static const List<dynamic> backActions = [
    kMiddleMouseButton,
    kBackMouseButton,
    LogicalKeyboardKey.arrowLeft,
  ];

  /// Lấy index từ phím A-Z
  static int? getAnswerIndex(LogicalKeyboardKey key) {
    final label = key.keyLabel.toUpperCase();
    if (label.length == 1 && label.contains(RegExp(r'[A-Z]'))) {
      return label.codeUnitAt(0) - 65; // A=0, B=1...
    }
    return null;
  }
}

class StudyPage extends HookConsumerWidget {
  final int sessionId;

  const StudyPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        final elapsedSeconds = useState<int>(session.studyTime);
        final isFinishingRef = useRef(false);
        final currentDetail = session.getCurrentLearningSessionDetail();

        if (currentDetail == null) return const SizedBox.shrink();
        if (currentDetail.learningSession.target == null) {
          currentDetail.learningSession.target = session;
        }

        // --- CORE LOGIC ---
        void performSave({bool isCompleted = false}) {
          if (isFinishingRef.value && !isCompleted) return;

          final details = session.learningSessionDetails;
          int correct = details.where((d) => d.isCorrect == true).length;
          int wrong = details
              .where((d) => d.isChecked && d.isCorrect == false)
              .length;

          session.studyTime = elapsedSeconds.value;
          session.totalCorrect = correct;
          session.totalWrong = wrong;
          session.isCompleted = isCompleted;
          if (isCompleted) session.endTime = DateTime.now();

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

        void handleCheckAction() {
          if (currentDetail.isChecked) {
            jumpToPage(session.currentIndex + 1);
          } else {
            ref
                .read(learningSessionDetailProvider(currentDetail.id).notifier)
                .checkQuestion(currentDetail.id);
            ref.invalidate(watchLearningSessionProvider(sessionId));
            performSave();
          }
        }

        // --- HOTKEY HANDLER ---
        void handleInput(dynamic input) {
          // 1. Xử lý các Action chính (Chuột hoặc Phím chức năng)
          if (StudyShortcuts.checkActions.contains(input)) {
            handleCheckAction();
            return;
          }

          if (StudyShortcuts.nextActions.contains(input)) {
            jumpToPage(session.currentIndex + 1);
            return;
          }

          if (StudyShortcuts.backActions.contains(input)) {
            jumpToPage(session.currentIndex - 1);
            return;
          }

          // 2. Xử lý chọn đáp án A-Z (Chỉ dành cho phím)
          if (input is LogicalKeyboardKey) {
            final index = StudyShortcuts.getAnswerIndex(input);
            if (index != null && !currentDetail.isChecked) {
              final answers = currentDetail.question.target?.answers ?? [];
              if (index < answers.length) {
                ref
                    .read(
                      learningSessionDetailProvider(currentDetail.id).notifier,
                    )
                    .toggleAnswer(currentDetail.id, answers[index]);
                ref.invalidate(watchLearningSessionProvider(sessionId));
              }
            }
          }
        }

        // --- EFFECTS ---
        useEffect(() {
          focusNode.requestFocus();
          final timer = Timer.periodic(
            const Duration(seconds: 1),
            (t) => elapsedSeconds.value++,
          );
          return () => timer.cancel();
        }, [sessionId]);

        final (eosHeader, fontSize, fontFamily) = useEosHeader(
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
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) => handleInput(event.buttons),
                child: Column(
                  children: [
                    eosHeader,
                    EosProgressRow(
                      answeredCount: session.learningSessionDetails
                          .where((d) => d.isChecked)
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
                            SizedBox(
                              width: 140.0,
                              child: EosAnswerColumn(
                                learningSessionDetail: currentDetail,
                                onAnswerSelected: (answer) {
                                  if (currentDetail.isChecked) return;
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
                                    label: currentDetail.isChecked
                                        ? "Next >>"
                                        : "Check",
                                    width: 110,
                                    color: currentDetail.isChecked
                                        ? LearningColors.nextButton
                                        : LearningColors.checkButton,
                                    onTap: handleCheckAction,
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1, color: Colors.grey),
                            EosFeedbackColumn(
                              width: feedbackColumnWidth,
                              learningSessionDetail: currentDetail,
                            ),
                            eosVerticalSplitter,
                            Expanded(
                              child: EosQuestionContent(
                                fontSize: fontSize,
                                fontFamily: fontFamily,
                                learningSessionDetail: currentDetail,
                                showAnswer: currentDetail.isChecked,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    EosBottomBar(
                      bgColor: const Color(0xFFD4D0C8),
                      rightActions: [
                        RetroButton(
                          label: "<< Back",
                          width: 85,
                          onTap: session.currentIndex > 0
                              ? () => jumpToPage(session.currentIndex - 1)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        RetroButton(
                          label: "Next >>",
                          width: 85,
                          onTap:
                              session.currentIndex <
                                  session.learningSessionDetails.length - 1
                              ? () => jumpToPage(session.currentIndex + 1)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        RetroButton(
                          label: "Finish",
                          width: 85,
                          color: Colors.green.shade100,
                          onTap: () async {
                            isFinishingRef.value = true;
                            performSave(isCompleted: true);
                            await container
                                .read(learningSessionProvider.notifier)
                                .completeSession(sessionId);
                            container.invalidate(watchLearningSessionsProvider);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
