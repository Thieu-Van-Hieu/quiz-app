import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/search/search_options.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/services/ocr/ocr_controller.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/features/library/notifiers/question_notifier.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/services/quiz/quiz_convert_service.dart';
import 'package:frontend/features/library/services/quiz/quiz_deduplicator.dart';
import 'package:frontend/features/library/widgets/question/ocr_loading_overlay.dart';
import 'package:frontend/features/library/widgets/question/question_filter_bar.dart';
import 'package:frontend/features/library/widgets/question/question_grid_view.dart';
import 'package:frontend/features/library/widgets/question/question_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionPage extends HookConsumerWidget {
  final int subjectId;
  final int quizId;

  /// Từ khoá & tuỳ chọn tìm kiếm ban đầu (vd. mở từ Master Search)
  final String? initialKeyword;
  final SearchOptions initialOptions;

  const QuestionPage({
    super.key,
    required this.subjectId,
    required this.quizId,
    this.initialKeyword,
    this.initialOptions = const SearchOptions(),
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

    final maxPage = ((totalItems - 1) / pageSize).floor();

    if (params.value.page > maxPage) {
      params.value = params.value.copyWith(page: maxPage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = useState(
      QuestionSearchParams(
        quizId: quizId,
        size: 10,
        page: 0,
        keyword: initialKeyword,
        options: initialOptions,
      ),
    );
    final searchError = TextMatcher(
      params.value.keyword ?? '',
      params.value.options,
    ).error;
    final showOnlyErrors = useState(false);
    final isOcrLoading = useState(false);

    final quizAsync = ref.watch(watchQuizProvider(quizId));
    final questionsAsync = ref.watch(questionProvider(quizId));
    final questionActions = ref.read(questionProvider(quizId).notifier);

    final allQuestions = questionsAsync.value;
    final duplicateCount = useMemoized(
      () => allQuestions == null
          ? 0
          : QuizDeduplicator.findDuplicates(allQuestions).length,
      [allQuestions],
    );

    void handleRemoveDuplicates() {
      final removed = questionActions.removeDuplicates();
      final total = ref.read(questionProvider(quizId)).value?.length ?? 0;
      _adjustPageAfterChange(total, params.value.size, params);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã xoá $removed câu trùng. Bấm \"Lưu DB\" để lưu thay đổi.",
          ),
        ),
      );
    }

    // Logic xử lý OCR (Đã dọn dẹp sạch log)
    Future<void> handleOcr() async {
      isOcrLoading.value = true;
      try {
        final result = await ref.read(ocrControllerProvider).scanScreen();

        if (result != "USER_CANCELLED" &&
            result != "BUSY" &&
            !result.startsWith("Lỗi")) {
          if (!context.mounted) return;

          final editedText = await _showOcrPreviewDialog(context, result);

          if (editedText != null && editedText.trim().isNotEmpty) {
            final questions = QuizConverterService.convertRawOcrToQuestions(
              editedText,
            );

            final beforeDuplicates = duplicateCount;
            for (var q in questions) {
              questionActions.addQuestion(q);
            }

            final afterDuplicates = QuizDeduplicator.findDuplicates(
              ref.read(questionProvider(quizId)).value ?? [],
            ).length;
            if (afterDuplicates > beforeDuplicates && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Có ${afterDuplicates - beforeDuplicates} câu vừa thêm bị trùng với câu đã có.",
                  ),
                  backgroundColor: Colors.orange.shade800,
                  action: SnackBarAction(
                    label: "Xoá trùng",
                    textColor: Colors.white,
                    onPressed: handleRemoveDuplicates,
                  ),
                ),
              );
            }

            final currentList = ref.read(questionProvider(quizId)).value ?? [];
            final total = currentList.length + questions.length;
            final lastPage = ((total - 1) / params.value.size).floor();
            params.value = params.value.copyWith(
              page: lastPage < 0 ? 0 : lastPage,
            );
          }
        }
      } catch (_) {
        // Handle silently or notify via UI if needed
      } finally {
        isOcrLoading.value = false;
      }
    }

    return Stack(
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
                duplicateCount: duplicateCount,
                onRemoveDuplicatesTap: handleRemoveDuplicates,
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
                        SnackBar(content: Text("Lỗi làm mới: ${e.toString()}")),
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
                questions: questionsAsync.hasValue ? questionsAsync.value! : [],
                onSearch: (val) =>
                    params.value = params.value.copyWith(keyword: val, page: 0),
                initialKeyword: initialKeyword ?? '',
                options: params.value.options,
                onOptionsChanged: (options) => params.value = params.value
                    .copyWith(options: options, page: 0),
                searchError: searchError,
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
                      questionActions.deleteQuestion(idx);

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
    );
  }
}

/// Dialog Preview Text giao diện xịn như QuizletImportDialog
Future<String?> _showOcrPreviewDialog(
  BuildContext context,
  String initialText,
) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _OcrPreviewDialog(initialText: initialText),
  );
}

class _OcrPreviewDialog extends HookWidget {
  final String initialText;

  const _OcrPreviewDialog({required this.initialText});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialText);

    return AppAlertDialog(
      title: "Kiểm tra nội dung OCR",
      size: AlertDialogSize.medium,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Vui lòng kiểm tra và chỉnh sửa lại các lỗi nhận diện trước khi nhập.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: "Nội dung nhận diện",
                hintText: "Nội dung nhận diện trống...",
                controller: controller,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          label: "Xác nhận & Thêm",
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context, controller.text),
        ),
      ],
    );
  }
}
