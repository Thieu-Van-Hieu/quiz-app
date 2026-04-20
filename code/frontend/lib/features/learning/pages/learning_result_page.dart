import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/pagination.dart'; // Widget Phân trang của phen
import 'package:frontend/core/widgets/search_bar.dart'; // Widget Search của phen
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/learning/widgets/learning_result/learning_result_item.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LearningResultPage extends HookConsumerWidget {
  const LearningResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Khởi tạo Params (Giống SubjectPage, mặc định trang 0, size 12)
    final params = useState(LearningSessionSearchParams(page: 0, size: 10));

    // 2. Watch dữ liệu (Stream cho list và Future/Stream cho tổng trang)
    final sessionsAsync = ref.watch(
      watchLearningSessionsProvider(params.value),
    );

    // Giả sử phen có provider này để lấy tổng số trang từ ObjectBox
    final totalPagesAsync = ref.watch(
      watchLearningSessionTotalPagesProvider(params.value),
    );

    // Trong build của LearningHistoryPage
    useEffect(() {
      // Cứ mỗi lần build (vào trang), ép provider xoá cache cũ và lấy cái mới nhất từ DB
      void _ = ref.refresh(watchLearningSessionsProvider(params.value));
      return null;
    }, []); // Mảng rỗng để chỉ chạy 1 lần khi init trang

    return Material(
      color: Colors.white, // Hoặc LibraryColors.background
      child: Padding(
        padding: const EdgeInsets.all(
          40.0,
        ), // Padding rộng rãi theo style của phen
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

            // SEARCH BAR: Khi gõ sẽ reset về trang 0
            AppSearchBar(
              onSearch: (v) =>
                  params.value = params.value.copyWith(keyword: v, page: 0),
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
                          // Khống chế chiều rộng tối đa của item để không chiếm hết hàng
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    350, // Mỗi card rộng tối đa 350px
                                mainAxisExtent: 340, // Chiều cao cố định
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                              ),
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final session = sessions[index];
                            return LearningResultItem(
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
                              onDelete: () =>
                                  _handleDelete(context, ref, session),
                            );
                          },
                        ),
                      ),

                      // PHÂN TRANG (PAGINATION)
                      const SizedBox(height: 24),
                      // Chỗ này phen gắn totalPages từ provider vào
                      totalPagesAsync.maybeWhen(
                        data: (total) => AppPagination(
                          currentPage: params.value.page,
                          totalPages: total,
                          onPageChange: (newPage) {
                            params.value = params.value.copyWith(page: newPage);
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

  // --- LOGIC XỬ LÝ (Giữ nguyên logic của phen) ---

  Future<void> _handleRetake(
    BuildContext context,
    WidgetRef ref,
    int oldId,
  ) async {
    // Gọi Notifier sạch, không cần truyền params nữa
    final notifier = ref.read(learningSessionProvider.notifier);
    try {
      final newSession = await notifier.retakeSession(oldId).withToast(context);
      if (context.mounted) {
        context.go(LearningRoutes.sessionPath(newSession?.id));
      }
    } catch (e) {
      // Xử lý lỗi hoặc hiện toast ở đây
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
      if (context.mounted) {
        context.go(LearningRoutes.sessionPath(newSession?.id));
      }
    } catch (e) {
      // Xử lý lỗi
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    LearningSession session,
  ) async {
    // itemName = subjectName + quizName, nếu không có thì lấy "Phiên học"
    String itemName = "";
    final quiz = session.quiz.target;
    if (quiz != null) {
      final subject = quiz.subject.target;
      if (subject != null) {
        itemName = "${subject.name} - ${quiz.name}";
      } else {
        itemName = quiz.name;
      }
    }
    if (itemName.isEmpty) {
      itemName = "Phiên học";
    }
    final sessionId = session.id;
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        itemName: itemName,
        onDelete: () async {
          await ref
              .read(learningSessionProvider.notifier)
              .deleteSession(sessionId)
              .withToast(context);
          ref.invalidate(watchLearningSessionProvider);
        },
      ),
    );
  }
}
