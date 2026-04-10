import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/constants/learning_strings.dart';
import 'package:frontend/features/learning/hooks/eos/use_header.dart';
import 'package:frontend/features/learning/hooks/eos/use_resizable.dart';
import 'package:frontend/features/learning/notifiers/learning_session_detail_notifier.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/widgets/eos/bottom_bar.dart';
import 'package:frontend/features/learning/widgets/eos/clock.dart';
import 'package:frontend/features/learning/widgets/eos/feedback_column.dart';
import 'package:frontend/features/learning/widgets/eos/progress_row.dart';
import 'package:frontend/features/learning/widgets/eos/question_content_column.dart';
import 'package:frontend/features/learning/widgets/retro/button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PracticeShortcuts {
  static const List<dynamic> toggleActions = [
    kSecondaryMouseButton,
    LogicalKeyboardKey.space,
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
}

class PracticePage extends HookConsumerWidget {
  final int sessionId;

  const PracticePage({super.key, required this.sessionId});

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
            child: Center(child: Text("Không tìm thấy session")),
          );
        }

        // Quản lý các trạng thái UI đơn giản
        final currentIndex = useState<int>(session.currentIndex);
        final elapsedSeconds = useState<int>(session.studyTime);
        final isShowingAnswer = useState<bool>(false);

        final isFinishingRef = useRef(false);

        // --- CORE LOGIC: LƯU ---
        // Sử dụng async/await để đảm bảo DB đã ghi xong
        Future<void> performSave({
          bool isCompleted = false,
          int? overrideIndex,
        }) async {
          if (isFinishingRef.value && !isCompleted) return;

          // Cập nhật trực tiếp lên Object để giữ Reference của ObjectBox
          session.studyTime = elapsedSeconds.value;
          session.currentIndex = overrideIndex ?? currentIndex.value;
          session.isCompleted = isCompleted;
          if (isCompleted) {
            session.endTime = DateTime.now();
          }

          await container
              .read(learningSessionProvider.notifier)
              .updateSession(session);
        }

        // --- CORE LOGIC: ĐIỀU HƯỚNG ---
        void jumpToPage(int newIndex) {
          final details = session.learningSessionDetails;
          if (newIndex >= 0 && newIndex < details.length) {
            currentIndex.value = newIndex;
            performSave(overrideIndex: newIndex);
          }
        }

        // --- CORE LOGIC: SHOW/HIDE ---
        void toggleShowAnswer() {
          final currentDetail = session.getCurrentLearningSessionDetail();
          if (currentDetail == null) return;

          isShowingAnswer.value = !isShowingAnswer.value;

          // Lưu trạng thái check vào DB
          container
              .read(learningSessionDetailProvider(currentDetail.id).notifier)
              .toggleCheckStatus(currentDetail.id);
        }

        // Cập nhật isShowingAnswer dựa trên trạng thái của câu hỏi hiện tại
        useEffect(() {
          final detail = session.learningSessionDetails[currentIndex.value];
          isShowingAnswer.value = detail.isChecked;
          return null;
        }, [currentIndex.value]);

        // --- HANDLERS ---
        void handleShortcut(dynamic input) {
          if (PracticeShortcuts.toggleActions.contains(input)) {
            toggleShowAnswer();
          } else if (PracticeShortcuts.nextActions.contains(input)) {
            jumpToPage(currentIndex.value + 1);
          } else if (PracticeShortcuts.backActions.contains(input)) {
            jumpToPage(currentIndex.value - 1);
          }
        }

        // --- TIMER ---
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

        // --- UI PRE-BUILD ---
        final currentDetail =
            session.learningSessionDetails[currentIndex.value];

        // Header & Resizable hooks
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
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Listener(
                                behavior: HitTestBehavior.opaque,
                                onPointerDown: (event) =>
                                    handleShortcut(event.buttons),
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

                          // 1. Lưu dữ liệu hiện tại
                          await performSave(isCompleted: true);

                          // 2. Chạy logic hoàn tất
                          await container
                              .read(learningSessionProvider.notifier)
                              .completeSession(sessionId);

                          // 3. Invalidate để History Page biết cần load lại (Dùng container để an toàn khi unmounted)
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
        );
      },
    );
  }
}
