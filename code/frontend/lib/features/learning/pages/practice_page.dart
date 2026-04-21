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
    // 1. Lấy dữ liệu cấu hình từ hệ thống
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

        // Lấy config thực tế hoặc dùng object mặc định nếu đang load
        final config = configAsync.maybeWhen(
          data: (c) => c,
          orElse: () => null,
        );

        final currentIndex = useState<int>(session.currentIndex);
        final elapsedSeconds = useState<int>(session.studyTime);
        final isShowingAnswer = useState<bool>(false);
        final isFinishingRef = useRef(false);

        // --- SHORTCUT MAPPER ---
        // Hàm này kiểm tra xem input (phím/chuột) có khớp với hành động đã cài đặt không
        bool isActionTriggered(ShortcutAction action, dynamic input) {
          if (config == null) return false;
          final bindings = config.keyBindings[action] ?? [];

          return bindings.any((physicalKey) {
            // Nếu input là bàn phím (LogicalKeyboardKey)
            if (input is LogicalKeyboardKey) {
              return KeyMaps.logicalToPhysical[input] == physicalKey;
            }
            // Nếu input là chuột (int - event.buttons)
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

        void toggleShowAnswer() {
          final currentDetail = session.getCurrentLearningSessionDetail();
          if (currentDetail == null) return;

          isShowingAnswer.value = !isShowingAnswer.value;
          container
              .read(learningSessionDetailProvider.notifier)
              .toggleCheckStatus(currentDetail.id);
        }

        // --- HANDLERS ---
        void handleShortcut(dynamic input) {
          if (isActionTriggered(ShortcutAction.toggleQuestion, input)) {
            toggleShowAnswer();
          } else if (isActionTriggered(ShortcutAction.nextQuestion, input)) {
            jumpToPage(currentIndex.value + 1);
          } else if (isActionTriggered(
            ShortcutAction.previousQuestion,
            input,
          )) {
            jumpToPage(currentIndex.value - 1);
          }
        }

        useEffect(() {
          final detail = session.learningSessionDetails[currentIndex.value];
          isShowingAnswer.value = detail.isChecked;
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

        final currentDetail =
            session.learningSessionDetails[currentIndex.value];

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
            // KEYBOARD LISTENER: Bọc toàn bộ trang
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
                    answeredCount: currentIndex.value,
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
                            // MOUSE SHORTCUTS: Chỉ bọc vùng Content câu hỏi
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Listener(
                                behavior: HitTestBehavior.opaque,
                                onPointerDown: (event) {
                                  focusNode
                                      .requestFocus(); // Đảm bảo luôn giữ focus cho phím
                                  handleShortcut(event.buttons);
                                },
                                child: EosQuestionContent(
                                  fontSize: fontSize,
                                  fontFamily: fontFamily,
                                  learningSessionDetail: currentDetail,
                                  showAnswer: isShowingAnswer.value,
                                ),
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
                      RetroButton(
                        label: "<< Back",
                        width: 85,
                        onTap: currentIndex.value > 0
                            ? () => jumpToPage(currentIndex.value - 1)
                            : null,
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
                            currentIndex.value <
                                session.learningSessionDetails.length - 1
                            ? () => jumpToPage(currentIndex.value + 1)
                            : null,
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
