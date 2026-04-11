import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/notifiers/question_notifier.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/services/quiz_convert_service.dart';
import 'package:frontend/features/library/widgets/question/question_item.dart';
import 'package:frontend/utils/ocr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionPage extends HookConsumerWidget {
  final int subjectId;
  final int quizId;

  const QuestionPage({
    super.key,
    required this.subjectId,
    required this.quizId,
  });

  /// Logic băm text và thêm câu hỏi
  void _processAndAddQuestions(String editedText, QuestionNotifier notifier) {
    final questions = QuizConverterService.convertRawOcrToQuestions(editedText);
    for (var q in questions) {
      notifier.addQuestion(q);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = useState(
      QuestionSearchParams(quizId: quizId, size: 10, page: 0),
    );
    final showOnlyErrors = useState(false);
    final isOcrLoading = useState(false);

    final quizAsync = ref.watch(watchQuizProvider(quizId));
    final questionsAsync = ref.watch(questionProvider(quizId));
    final questionActions = ref.read(questionProvider(quizId).notifier);

    final quizName = quizAsync.maybeWhen(
      data: (quiz) => quiz?.name ?? "Không xác định",
      loading: () => AppStrings.loading,
      orElse: () => AppStrings.error,
    );

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  context,
                  quizName,
                  questionsAsync,
                  questionActions,
                  isOcrLoading,
                ),
                const SizedBox(height: 32),
                _buildFilterRow(params, questionsAsync, showOnlyErrors),
                const SizedBox(height: 32),
                Expanded(
                  child: questionsAsync.when(
                    data: (allQuestions) {
                      final errorQuestions = allQuestions.where(
                        (q) => q.explanation.contains(
                          QuizConverterService.errorFlag,
                        ),
                      );

                      // 2. TỰ ĐỘNG KHÔI PHỤC: Nếu đang bật "Xem lỗi" mà thực tế không còn lỗi nào
                      if (showOnlyErrors.value && errorQuestions.isEmpty) {
                        // Dùng Future.microtask để tránh lỗi "setState during build"
                        Future.microtask(() => showOnlyErrors.value = false);
                      }

                      // 3. Quyết định danh sách gốc để lọc tiếp theo Keyword
                      Iterable<Question> baseFiltered = showOnlyErrors.value
                          ? errorQuestions
                          : allQuestions;

                      // 4. Lọc theo keyword (giữ nguyên logic của bạn)
                      final filtered = baseFiltered.where((q) {
                        final kw = params.value.keyword?.toLowerCase() ?? '';
                        return q.content.toLowerCase().contains(kw) ||
                            q.answers.any(
                              (a) => a.content.toLowerCase().contains(kw),
                            );
                      }).toList();

                      // Nếu danh sách trống
                      if (filtered.isEmpty) {
                        return _buildEmptyState(allQuestions.isEmpty);
                      }

                      // Tính toán Pagination
                      final totalItems = filtered.length;
                      final totalPages = (totalItems / params.value.size)
                          .ceil();
                      final start = params.value.page * params.value.size;
                      final end = (start + params.value.size) > totalItems
                          ? totalItems
                          : (start + params.value.size);
                      final pagedList = filtered.sublist(start, end);

                      return Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 600,
                                    mainAxisExtent: 520,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 24,
                                  ),
                              itemCount: pagedList.length,
                              itemBuilder: (context, index) {
                                final question = pagedList[index];
                                final realIndex = allQuestions.indexOf(
                                  question,
                                );
                                return QuestionItem(
                                  key: ObjectKey(question),
                                  index:
                                      (params.value.page * params.value.size) +
                                      index +
                                      1,
                                  question: question,
                                  isNew: question.content.isEmpty,
                                  onSave: (updated) => questionActions
                                      .updateQuestion(realIndex, updated),
                                  onDelete: () =>
                                      questionActions.deleteQuestion(realIndex),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppPagination(
                            currentPage: params.value.page,
                            totalPages: totalPages,
                            activeColor: LibraryColors.accentColor,
                            onPageChange: (newPage) => params.value = params
                                .value
                                .copyWith(page: newPage),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Lỗi hệ thống: $e")),
                  ),
                ),
              ],
            ),
          ),
          // Overlay khi đang quét OCR
          if (isOcrLoading.value)
            Container(
              color: Colors.black45,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          "Đang chờ quét vùng màn hình...",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Vui lòng chọn vùng chứa câu hỏi",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isQuizEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            isQuizEmpty
                ? "Quiz chưa có câu hỏi nào"
                : "Không tìm thấy kết quả phù hợp",
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          if (isQuizEmpty)
            const Text(
              "Bấm 'Quét ảnh' hoặc 'Thêm câu hỏi' để bắt đầu",
              style: TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(
    ValueNotifier<QuestionSearchParams> params,
    AsyncValue<List<Question>> questionsAsync,
    ValueNotifier<bool> showOnlyErrors,
  ) {
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: LibraryStrings.searchQuestionHint,
            onSearch: (v) =>
                params.value = params.value.copyWith(keyword: v, page: 0),
          ),
        ),
        const SizedBox(width: 16),
        questionsAsync.maybeWhen(
          data: (list) {
            final errorCount = list
                .where(
                  (q) => q.explanation.contains(QuizConverterService.errorFlag),
                )
                .length;
            if (errorCount == 0) return const SizedBox.shrink();
            return FilterChip(
              label: Text("Câu lỗi ($errorCount)"),
              selected: showOnlyErrors.value,
              onSelected: (val) {
                showOnlyErrors.value = val;
                params.value = params.value.copyWith(page: 0);
              },
              backgroundColor: Colors.red.shade50,
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red,
              labelStyle: TextStyle(
                color: showOnlyErrors.value ? Colors.red : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String quizName,
    AsyncValue<List<Question>> questionsAsync,
    QuestionNotifier notifier,
    ValueNotifier<bool> isOcrLoading,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: LibraryColors.primaryText,
              ),
            ),
            questionsAsync.maybeWhen(
              data: (list) => Text(
                "${list.length} câu hỏi hiện có",
                style: const TextStyle(color: LibraryColors.secondaryText),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const Spacer(),
        _HeaderButton(
          onPressed: () async {
            isOcrLoading.value = true;
            try {
              final result = await OcrUtils().processOcr();
              isOcrLoading.value = false;

              if (result != "USER_CANCELLED" && !result.startsWith("Lỗi")) {
                if (context.mounted) {
                  final editedText = await _showOcrPreviewDialog(
                    context,
                    result,
                  );
                  if (editedText != null && editedText.trim().isNotEmpty) {
                    _processAndAddQuestions(editedText, notifier);
                  }
                }
              }
            } catch (e) {
              debugPrint("Lỗi OCR: $e");
            } finally {
              isOcrLoading.value = false;
            }
          },
          icon: Icons.camera_enhance_rounded,
          label: "Quét ảnh",
          color: LibraryColors.accentColor,
        ),
        const SizedBox(width: 16),
        _HeaderButton(
          onPressed: () => notifier.refresh(),
          icon: Icons.refresh_rounded,
          label: "Tải lại",
          color: LibraryColors.secondaryText,
        ),
        const SizedBox(width: 16),
        _HeaderButton(
          onPressed: () => notifier.saveToDb(),
          icon: Icons.cloud_upload_outlined,
          label: "Lưu DB",
          color: AppColors.success,
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            final q = Question(content: "", explanation: "");
            q.answers.addAll([
              Answer(content: "", isCorrect: true),
              Answer(content: "", isCorrect: false),
            ]);
            notifier.addQuestion(q);
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text("Thêm câu hỏi"),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _HeaderButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Dialog Preview Text trước khi băm
Future<String?> _showOcrPreviewDialog(
  BuildContext context,
  String initialText,
) async {
  final controller = TextEditingController(text: initialText);
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.edit_note, color: LibraryColors.accentColor),
          SizedBox(width: 8),
          Text("Kiểm tra nội dung OCR"),
        ],
      ),
      content: SizedBox(
        width: 900,
        height: 600,
        child: Column(
          children: [
            const Text(
              "Vui lòng chỉnh sửa lại các lỗi nhận diện (nếu có) trước khi thêm.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nội dung trống...",
                  fillColor: Color(0xFFF9F9F9),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy bỏ"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
          ),
          child: const Text(
            "Xác nhận & Thêm",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
