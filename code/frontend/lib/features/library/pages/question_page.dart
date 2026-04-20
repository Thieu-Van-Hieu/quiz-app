import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/notifiers/question_notifier.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/services/quiz/quiz_convert_service.dart';
import 'package:frontend/features/library/widgets/question/ocr_loading_overlay.dart';
import 'package:frontend/features/library/widgets/question/question_filter_bar.dart';
import 'package:frontend/features/library/widgets/question/question_grid_view.dart';
import 'package:frontend/features/library/widgets/question/question_header.dart';
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

  /// Hàm helper giúp điều chỉnh trang sau khi thay đổi dữ liệu
  void _adjustPageAfterChange(
    int totalItems,
    int pageSize,
    ValueNotifier<QuestionSearchParams> params,
  ) {
    if (totalItems <= 0) {
      if (params.value.page != 0) {
        params.value = params.value.copyWith(page: 0);
      }
      return;
    }

    // Tính trang cuối cùng có thể có (0-based)
    final maxPage = ((totalItems - 1) / pageSize).floor();

    // Nếu trang hiện tại lớn hơn trang cuối, lùi về trang cuối
    if (params.value.page > maxPage) {
      params.value = params.value.copyWith(page: maxPage);
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

    // Logic xử lý OCR
    Future<void> handleOcr() async {
      isOcrLoading.value = true;
      try {
        final result = await OcrUtils().processOcr();
        if (result != "USER_CANCELLED" && !result.startsWith("Lỗi")) {
          if (context.mounted) {
            final editedText = await _showOcrPreviewDialog(context, result);
            if (editedText != null && editedText.trim().isNotEmpty) {
              final questions = QuizConverterService.convertRawOcrToQuestions(
                editedText,
              );
              for (var q in questions) {
                questionActions.addQuestion(q);
              }

              // Sau khi thêm hàng loạt, tự động nhảy về trang cuối cùng
              final currentList =
                  ref.read(questionProvider(quizId)).value ?? [];
              final total = currentList.length + questions.length;
              final lastPage = ((total - 1) / params.value.size).floor();
              params.value = params.value.copyWith(
                page: lastPage < 0 ? 0 : lastPage,
              );
            }
          }
        }
      } catch (e) {
        debugPrint("Lỗi OCR: $e");
      } finally {
        isOcrLoading.value = false;
      }
    }

    return Material(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                // 1. Header
                QuestionHeader(
                  quizName: quizAsync.maybeWhen(
                    data: (q) => q?.name ?? "Không xác định",
                    orElse: () => AppStrings.loading,
                  ),
                  numberOfQuestion: questionsAsync.hasValue
                      ? questionsAsync.value!.length
                      : 0,
                  onOcrTap: handleOcr,
                  onRefreshTap: () async {
                    try {
                      await questionActions.refresh();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đã cập nhật dữ liệu mới nhất"),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Lỗi làm mới: ${e.toString()}"),
                          ),
                        );
                      }
                    }
                  },
                  onSaveTap: () async {
                    try {
                      await questionActions.saveToDb();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lưu câu hỏi thành công!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Lỗi: ${e.toString()}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  onAddTap: () {
                    final q = Question(content: "", explanation: "");
                    q.setAsDraft();
                    q.answers.addAll([
                      Answer(content: "", isCorrect: true),
                      Answer(content: "", isCorrect: false),
                    ]);

                    questionActions.addQuestion(q);

                    // Tính toán và nhảy trang sau khi thêm
                    final currentList =
                        ref.read(questionProvider(quizId)).value ?? [];
                    final totalItems = currentList.length + 1;
                    final newPage = ((totalItems - 1) / params.value.size)
                        .floor();
                    params.value = params.value.copyWith(page: newPage);
                  },
                ),
                const SizedBox(height: 32),

                // 2. Filter Bar
                QuestionFilterBar(
                  questions: questionsAsync.hasValue
                      ? questionsAsync.value!
                      : [],
                  onSearch: (val) => params.value = params.value.copyWith(
                    keyword: val,
                    page: 0,
                  ),
                  showOnlyErrors: showOnlyErrors.value,
                  onToggleError: (val) {
                    showOnlyErrors.value = val;
                    params.value = params.value.copyWith(page: 0);
                  },
                ),
                const SizedBox(height: 32),

                // 3. Grid View
                Expanded(
                  child: questionsAsync.when(
                    data: (allQuestions) => QuestionGridView(
                      allQuestions: allQuestions,
                      params: params.value,
                      showOnlyErrors: showOnlyErrors.value,
                      onPageChange: (newPage) =>
                          params.value = params.value.copyWith(page: newPage),
                      onUpdate: (idx, q) =>
                          questionActions.updateQuestion(idx, q),
                      onDelete: (idx) async {
                        // Xóa và đợi kết quả
                        questionActions.deleteQuestion(idx);

                        // Sau khi xóa, kiểm tra lại danh sách để lùi trang nếu cần
                        final newList =
                            ref.read(questionProvider(quizId)).value ?? [];
                        _adjustPageAfterChange(
                          newList.length,
                          params.value.size,
                          params,
                        );
                      },
                      onAutoDisableError: () => showOnlyErrors.value = false,
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Lỗi hệ thống: $e")),
                  ),
                ),
              ],
            ),
          ),
          if (isOcrLoading.value) const OcrLoadingOverlay(),
        ],
      ),
    );
  }
}

/// Dialog Preview Text
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
              "Vui lòng chỉnh sửa lại các lỗi nhận diện trước khi thêm.",
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
