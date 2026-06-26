import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/constants/learning_colors.dart';
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
    // 1. Lấy dữ liệu cấu hình từ hệ thống
    final configAsync = ref.watch(watchAppConfigProvider);
    final sessionAsync = ref.watch(watchLearningSessionProvider(sessionId));
    final focusNode = useFocusNode();
    final container = ProviderScope.containerOf(context);

    // Sử dụng ObjectRef để lưu session mới nhất, tránh bị lỗi Stale Closure khi dispose
    final latestSessionRef = useRef<dynamic>(null);
    final latestSecondsRef = useRef<int>(0);

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

        // Cập nhật giá trị session mới nhất qua mỗi lượt build
        latestSessionRef.value = session;

        // Lấy config thực tế hoặc dùng object mặc định nếu đang load
        final config = configAsync.maybeWhen(
          data: (c) => c,
          orElse: () => null,
        );

        final elapsedSeconds = useState<int>(session.studyTime);
        // Đồng bộ hóa thời gian vào ref để hàm hủy luôn đọc được giây mới nhất
        latestSecondsRef.value = elapsedSeconds.value;

        final isFinishingRef = useRef(false);
        final currentDetail = session.getCurrentLearningSessionDetail();

        if (currentDetail == null) return const SizedBox.shrink();
        if (currentDetail.learningSession.target == null) {
          currentDetail.learningSession.target = session;
        }

        final isLastQuestion =
            session.currentIndex == session.learningSessionDetails.length - 1;

        // --- CORE LOGIC ---
        void performSave({bool isCompleted = false}) {
          if (isFinishingRef.value && !isCompleted) return;

          final currentSession = latestSessionRef.value;
          if (currentSession == null) return;

          final details = currentSession.learningSessionDetails;
          int correct = details.where((d) => d.isCorrect == true).length;
          int wrong = details
              .where((d) => d.isChecked && d.isCorrect == false)
              .length;

          currentSession.studyTime = latestSecondsRef.value;
          currentSession.totalCorrect = correct;
          currentSession.totalWrong = wrong;
          currentSession.isCompleted = isCompleted;
          if (isCompleted) currentSession.endTime = DateTime.now();

          container
              .read(learningSessionProvider.notifier)
              .updateSession(currentSession);
        }

        Future<void> handleFinishExam() async {
          isFinishingRef.value = true;
          performSave(isCompleted: true);
          await container
              .read(learningSessionProvider.notifier)
              .completeSession(sessionId);
          if (context.mounted) {
            context.go(LearningRoutes.sessionPath(sessionId));
          }
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

        // --- HANDLERS ---
        void handleCheckAction() {
          if (currentDetail.isChecked) {
            // Nếu là câu cuối cùng mà đã check rồi -> Hoàn thành luôn
            if (isLastQuestion) {
              handleFinishExam();
            } else {
              // Nếu chưa phải câu cuối -> Nhảy sang câu tiếp theo
              final nextIndex = session.currentIndex + 1;
              session.currentIndex = nextIndex;
              session.studyTime = elapsedSeconds.value;
              container
                  .read(learningSessionProvider.notifier)
                  .updateSession(session);
            }
          } else {
            // Nếu chưa check thì thực hiện check
            ref
                .read(learningSessionDetailProvider.notifier)
                .checkQuestion(currentDetail.id);
            session.studyTime = elapsedSeconds.value;
            container
                .read(learningSessionProvider.notifier)
                .updateSession(session);
          }
        }

        // --- SHORTCUT LOGIC ---
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
            final answers = currentDetail.question.target?.answers ?? [];
            if (index < answers.length) {
              container
                  .read(learningSessionDetailProvider.notifier)
                  .toggleAnswer(currentDetail.id, answers[index]);
            }
          }
        }

        void handleInput(dynamic input) {
          if (isActionTriggered(ShortcutAction.checkQuestion, input)) {
            handleCheckAction();
          } else if (isActionTriggered(ShortcutAction.nextQuestion, input)) {
            if (!isLastQuestion) jumpToPage(session.currentIndex + 1);
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
          final timer = Timer.periodic(
            const Duration(seconds: 1),
            (t) => elapsedSeconds.value++,
          );
          return () {
            timer.cancel();
            if (!isFinishingRef.value) performSave();
          };
        }, [sessionId]);

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
                                              : LearningColors.nextButton)
                                        : LearningColors.checkButton,
                                    onTap: handleCheckAction,
                                  ),
                                ],
                              ),
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
                      // Nếu là câu cuối cùng, không hiển thị nút Next nữa, chỉ hiển thị duy nhất nút Finish
                      if (!isLastQuestion) ...[
                        RetroButton(
                          label: "Next >>",
                          width: 85,
                          onTap: () => jumpToPage(session.currentIndex + 1),
                        ),
                        const SizedBox(width: 16),
                      ],
                      RetroButton(
                        label: "Finish",
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
