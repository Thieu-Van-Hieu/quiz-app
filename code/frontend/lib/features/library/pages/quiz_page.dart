import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/learning/widgets/learning_setting_dialog.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/quiz_search_params.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/services/quiz_convert_service.dart';
import 'package:frontend/features/library/widgets/quiz/add_dialog.dart';
import 'package:frontend/features/library/widgets/quiz/quiz_header.dart';
import 'package:frontend/features/library/widgets/quiz/quiz_item.dart';
import 'package:frontend/features/library/widgets/quiz/quizlet_export_dialog.dart';
import 'package:frontend/features/library/widgets/quiz/quizlet_import_dialog.dart';
import 'package:frontend/features/library/widgets/quiz/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizPage extends HookConsumerWidget {
  final int subjectId;

  const QuizPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchParamsNotifier = useState(
      QuizSearchParams(subjectId: subjectId, size: 10, page: 0),
    );
    final quizzesAsync = ref.watch(quizProvider(searchParamsNotifier.value));
    final totalPagesAsync = ref.watch(
      quizTotalPagesProvider(searchParamsNotifier.value),
    );

    // --- LOGIC XỬ LÝ DỮ LIỆU ---

    Future<void> handleExportJson(Quiz quiz) async {
      try {
        final jsonStr = QuizConverterService.exportQuizToJson(quiz);
        final bytes = utf8.encode(jsonStr);
        final outputFile = await FilePicker.saveFile(
          dialogTitle: 'Chọn nơi lưu bộ đề',
          fileName: '${quiz.name}.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
          bytes: bytes,
        );

        if (outputFile != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đã xuất file thành công: ${quiz.name}.json"),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Lỗi Export: $e")));
        }
      }
    }

    Future<void> handleImport(bool isBinary) async {
      try {
        FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: isBinary ? ['bin', 'dat'] : ['json'],
          withData: true,
        );

        if (result != null && result.files.single.bytes != null) {
          final bytes = result.files.single.bytes!;
          late Quiz newQuiz;

          if (isBinary) {
            newQuiz = QuizConverterService.importFromLegacyBinary(
              bytes,
              quizName: result.files.single.name.split('.').first,
            );
          } else {
            newQuiz = QuizConverterService.importAsNew(utf8.decode(bytes));
          }

          if (context.mounted) {
            await ref
                .read(quizProvider(searchParamsNotifier.value).notifier)
                .saveQuiz(subjectId, newQuiz)
                .withToast(context);
          } else {
            await ref
                .read(quizProvider(searchParamsNotifier.value).notifier)
                .saveQuiz(subjectId, newQuiz);
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Lỗi Import: $e")));
        }
      }
    }

    Future<void> handleQuizletImport() async {
      final Map<String, String>? result = await showDialog<Map<String, String>>(
        context: context,
        builder: (ctx) => const QuizletImportDialog(),
      );

      if (result != null &&
          result['text']!.trim().isNotEmpty &&
          context.mounted) {
        try {
          String parse(String input) =>
              input.replaceAll("\\t", "\t").replaceAll("\\n", "\n");

          final newQuiz = QuizConverterService.convertQuizletToQuiz(
            result['text']!,
            termDefSeparator: parse(result['termDef']!), // Dùng dấu tùy chỉnh
            rowSeparator: parse(result['row']!), // Dùng dấu tùy chỉnh
            quizName: "Import ${DateTime.now().hour}:${DateTime.now().minute}",
          );

          // Đếm số câu lỗi
          int errorCount = newQuiz.questions
              .where((q) => q.content.startsWith('['))
              .length;

          await ref
              .read(quizProvider(searchParamsNotifier.value).notifier)
              .saveQuiz(subjectId, newQuiz)
              .withToast(context);

          if (errorCount > 0 && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Phát hiện $errorCount câu lỗi định dạng. Vui lòng kiểm tra các câu có đánh dấu [LỖI]",
                ),
                backgroundColor: Colors.orange.shade800,
                duration: const Duration(seconds: 6),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Lỗi xử lý Quizlet: $e")));
          }
        }
      }
    }

    // HÀM MỚI: Export ra Quizlet (Copy vào Clipboard)
    Future<void> handleQuizletExport(Quiz quiz) async {
      // 1. Hiện dialog để người dùng chọn định dạng muốn Export
      final Map<String, String>? config = await showDialog<Map<String, String>>(
        context: context,
        builder: (ctx) =>
            const QuizletExportDialog(), // Tạo mới dialog này bên dưới
      );

      if (config == null) return;

      try {
        String parse(String input) =>
            input.replaceAll("\\t", "\t").replaceAll("\\n", "\n");

        final quizletRaw = QuizConverterService.exportToQuizletRaw(
          quiz,
          termDefSeparator: parse(config['termDef']!),
          rowSeparator: parse(config['row']!),
        );

        await Clipboard.setData(ClipboardData(text: quizletRaw));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Đã sao chép với định dạng tùy chỉnh!"),
              backgroundColor: Colors.blue.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Lỗi Export: $e")));
        }
      }
    }

    // --- RENDER ---
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuizHeader(
            onImport: handleImport,
            onQuizletImport: handleQuizletImport,
            onAddManual: () =>
                _showAddQuizDialog(context, ref, searchParamsNotifier),
          ),
          const SizedBox(height: 40),
          AppSearchBar(
            onSearch: (v) => searchParamsNotifier.value = searchParamsNotifier
                .value
                .copyWith(keyword: v, page: 0),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: quizzesAsync.when(
              data: (quizzes) => Column(
                children: [
                  Expanded(
                    child: quizzes.isEmpty
                        ? const Center(child: Text(AppStrings.noData))
                        : GridView.builder(
                            itemCount: quizzes.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  mainAxisExtent: 180,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                ),
                            itemBuilder: (context, index) => QuizItem(
                              quiz: quizzes[index],
                              onTap: () => _onQuizTap(
                                context,
                                ref,
                                quizzes[index],
                                searchParamsNotifier.value,
                              ),
                              onEdit: () => _showUpdateQuizDialog(
                                context,
                                ref,
                                quizzes[index],
                              ),
                              onDelete: () => _confirmDelete(
                                context,
                                ref,
                                quizzes[index],
                                quizzes,
                                searchParamsNotifier,
                              ),
                              onLearn: () => _startLearningMode(
                                context,
                                ref,
                                quizzes[index],
                              ),
                              onExportJson: () =>
                                  handleExportJson(quizzes[index]),
                              onExportQuizlet: () =>
                                  handleQuizletExport(quizzes[index]),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  totalPagesAsync.maybeWhen(
                    data: (total) => AppPagination(
                      currentPage: searchParamsNotifier.value.page,
                      totalPages: total,
                      onPageChange: (p) => searchParamsNotifier.value =
                          searchParamsNotifier.value.copyWith(page: p),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Lỗi: $e")),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTIONS --- (Giữ nguyên các hàm _show...Dialog của phen)
  void _startLearningMode(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => LearningSettingDialog(
        totalQuestions: quiz.questions.length,
        onConfirm: (settings) async {
          final sessionNotifier = ref.read(learningSessionProvider.notifier);
          try {
            final newSession = await sessionNotifier.createSession(
              quizId: quiz.id,
              setting: settings,
            );
            if (context.mounted) {
              context.go(LearningRoutes.sessionPath(newSession.id));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
            }
          }
        },
      ),
    );
  }

  void _showAddQuizDialog(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<QuizSearchParams> paramsNotifier, // Thêm tham số này
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AddQuizDialog(
        onSave: (name) async {
          // Chuyển thành async
          // 1. Lưu quiz
          await ref
              .read(quizProvider(paramsNotifier.value).notifier)
              .saveQuiz(subjectId, Quiz(name: name))
              .withToast(context);

          // 2. Lấy số trang mới nhất sau khi lưu
          // Lưu ý: ref.read(provider.future) giúp lấy giá trị mới nhất từ provider
          final newTotalPages = await ref.read(
            quizTotalPagesProvider(paramsNotifier.value).future,
          );

          // 3. Nhảy tới trang cuối cùng
          if (newTotalPages > 0) {
            paramsNotifier.value = paramsNotifier.value.copyWith(
              page: newTotalPages - 1,
            );
          }
        },
      ),
    );
  }

  void _showUpdateQuizDialog(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => UpdateQuizDialog(
        quiz: quiz,
        onUpdate: (newName) {
          quiz.name = newName;
          ref
              .read(
                quizProvider(QuizSearchParams(subjectId: subjectId)).notifier,
              )
              .saveQuiz(subjectId, quiz)
              .withToast(context);
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
    List<Quiz> currentQuizzes, // Thêm danh sách quiz hiện tại
    ValueNotifier<QuizSearchParams> paramsNotifier, // Thêm params notifier
  ) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmDialog(
        itemName: quiz.name,
        onDelete: () async {
          // Thực hiện xóa
          await ref
              .read(quizProvider(paramsNotifier.value).notifier)
              .deleteQuiz(quiz.id)
              .withToast(context);

          // LOGIC QUAY TRANG:
          // Nếu đây là item cuối cùng của trang hiện tại (và không phải trang 0)
          // thì lùi về trang trước đó.
          if (currentQuizzes.length == 1 && paramsNotifier.value.page > 0) {
            paramsNotifier.value = paramsNotifier.value.copyWith(
              page: paramsNotifier.value.page - 1,
            );
          }
        },
      ),
    );
  }

  void _onQuizTap(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
    QuizSearchParams currentParams,
  ) async {
    await context.push(LibraryRoutes.getQuizDetailPath(subjectId, quiz.id));

    // Bây giờ đã có currentParams để dùng
    ref.invalidate(quizProvider(currentParams));
  }
}
