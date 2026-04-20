import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/extensions/future_toast_extension.dart';
import 'package:frontend/core/widgets/delete_confirm_dialog.dart';
import 'package:frontend/core/widgets/pagination.dart';
import 'package:frontend/core/widgets/search_bar.dart';
import 'package:frontend/features/learning/notifiers/learning_session_notifier.dart';
import 'package:frontend/features/learning/routes/learning_routes.dart';
import 'package:frontend/features/learning/widgets/learning_setting_dialog.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/quiz_search_params.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/library/services/quiz_convert_service.dart';
import 'package:frontend/features/library/widgets/quiz/quiz_item.dart';
import 'package:frontend/features/library/widgets/quiz/update_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizPage extends HookConsumerWidget {
  final int subjectId;

  const QuizPage({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = useState(
      QuizSearchParams(subjectId: subjectId, size: 10, page: 0),
    );
    final quizzesAsync = ref.watch(quizProvider(params.value));
    final totalPagesAsync = ref.watch(quizTotalPagesProvider(params.value));

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
                .read(quizProvider(params.value).notifier)
                .saveQuiz(subjectId, newQuiz)
                .withToast(context);
          } else {
            await ref
                .read(quizProvider(params.value).notifier)
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
        builder: (ctx) => const _QuizletImportDialog(),
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
              .read(quizProvider(params.value).notifier)
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
            const _QuizletExportConfigDialog(), // Tạo mới dialog này bên dưới
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
          _SubjectHeader(
            onImport: handleImport,
            onQuizletImport: handleQuizletImport,
            onAddManual: () => _showAddQuizDialog(context, ref),
          ),
          const SizedBox(height: 40),
          AppSearchBar(
            onSearch: (v) =>
                params.value = params.value.copyWith(keyword: v, page: 0),
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
                                params.value,
                              ),
                              onEdit: () => _showUpdateQuizDialog(
                                context,
                                ref,
                                quizzes[index],
                              ),
                              onDelete: () =>
                                  _confirmDelete(context, ref, quizzes[index]),
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
                      currentPage: params.value.page,
                      totalPages: total,
                      onPageChange: (p) =>
                          params.value = params.value.copyWith(page: p),
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

  void _showAddQuizDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _AddManualQuizDialog(
        onSave: (name) {
          ref
              .read(
                quizProvider(QuizSearchParams(subjectId: subjectId)).notifier,
              )
              .saveQuiz(subjectId, Quiz(name: name))
              .withToast(context);
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Quiz quiz) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteConfirmDialog(
        itemName: quiz.name,
        onDelete: () {
          ref
              .read(
                quizProvider(QuizSearchParams(subjectId: subjectId)).notifier,
              )
              .deleteQuiz(quiz.id)
              .withToast(context);
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

// --- SUB-WIDGETS ---

class _SubjectHeader extends StatelessWidget {
  final Function(bool) onImport;
  final VoidCallback onQuizletImport;
  final VoidCallback onAddManual;

  const _SubjectHeader({
    required this.onImport,
    required this.onQuizletImport,
    required this.onAddManual,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LibraryStrings.detailTitle,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            Text(
              LibraryStrings.detailSubtitle,
              style: TextStyle(
                color: LibraryColors.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildHeaderButton(
              icon: Icons.file_download_outlined,
              label: "Import",
              isOutlined: true,
              onPressed: () {},
              // Thêm rỗng để kích hoạt GestureDetector bên trong
              isPopup: true,
              popupItems: [
                const PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.data_object),
                    title: Text("JSON"),
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Binary"),
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome),
                    title: Text("Quizlet (Beta)"),
                  ),
                ),
              ],
              onPopupSelected: (val) {
                if (val == 0) onImport(false);
                if (val == 1) onImport(true);
                if (val == 2) onQuizletImport();
              },
            ),
            const SizedBox(width: 16),
            _buildHeaderButton(
              icon: Icons.add_rounded,
              label: LibraryStrings.btnAddQuiz,
              onPressed: onAddManual,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isOutlined = false,
    bool isPopup = false,
    List<PopupMenuEntry<int>>? popupItems,
    Function(int)? onPopupSelected,
  }) {
    // 1. Tạo giao diện nút chuẩn
    final buttonContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : LibraryColors.accentColor,
        border: isOutlined
            ? Border.all(
                color: LibraryColors.accentColor.withValues(alpha: 0.5),
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isOutlined ? LibraryColors.accentColor : Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isOutlined ? LibraryColors.accentColor : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    // 2. Xử lý logic Click & Pointer tùy theo loại nút
    if (isPopup) {
      return PopupMenuButton<int>(
        offset: const Offset(0, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onPopupSelected,
        itemBuilder: (ctx) => popupItems!,
        // Dùng MouseRegion bọc ngoài Content bên trong Child của PopupMenu
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: buttonContent,
        ),
      );
    }

    // Nút bình thường
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onPressed, child: buttonContent),
    );
  }
}

class _QuizletImportDialog extends HookWidget {
  const _QuizletImportDialog();

  static String _formatTextHeavy(String text) {
    // Xử lý logic nặng ở đây
    return text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final termDefSep = useTextEditingController(text: "\\t");
    final rowSep = useTextEditingController(text: "\\n");
    final isLoading = useState<bool>(false);

    Future<void> handlePaste() async {
      if (isLoading.value) return;

      final sw = Stopwatch()..start();
      isLoading.value = true;

      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);

        if (data?.text != null && data!.text!.isNotEmpty) {
          // Bước 1: Parse logic
          final processedText = await compute(
            _QuizletImportDialog._formatTextHeavy,
            data.text!,
          );

          // Bước 2: Gán vào controller
          // Đây là lúc khả năng cao nhất gây đứng hình
          controller.value = TextEditingValue(
            text: processedText.substring(0, 5000),
            selection: TextSelection.collapsed(offset: 0),
          );

          // 2. Đợi UI render xong frame đầu tiên rồi mới nạp nốt phần còn lại
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration(milliseconds: 100), () {
              controller.value = TextEditingValue(
                text: processedText,
                selection: TextSelection.collapsed(
                  offset: processedText.length,
                ),
              );
            });
          });

          // Bước 3: Đợi frame kế tiếp để render xong
          await SchedulerBinding.instance.endOfFrame;
        }
      } catch (e) {
        debugPrint("Lỗi paste: $e");
      } finally {
        isLoading.value = false;
      }
    }

    return AlertDialog(
      title: const Text("Nhập từ Quizlet"),
      content: SizedBox(
        width: 600,
        height: 400,
        child: Column(
          children: [
            Expanded(
              // DÙNG STACK ĐỂ KHÔNG HỦY WIDGET KHI LOADING
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // TextField luôn tồn tại, chỉ ẩn đi khi loading
                  Opacity(
                    opacity: isLoading.value ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: isLoading.value,
                      child: Shortcuts(
                        shortcuts: {
                          LogicalKeySet(
                            LogicalKeyboardKey.control,
                            LogicalKeyboardKey.keyV,
                          ): const _CustomPasteIntent(),
                          LogicalKeySet(
                            LogicalKeyboardKey.meta,
                            LogicalKeyboardKey.keyV,
                          ): const _CustomPasteIntent(),
                        },
                        child: Actions(
                          actions: {
                            _CustomPasteIntent: CallbackAction(
                              onInvoke: (_) => handlePaste(),
                            ),
                          },
                          child: TextField(
                            controller: controller,
                            // QUAN TRỌNG: Tắt kiểm tra chính tả để tránh lag khi dán text dài
                            spellCheckConfiguration:
                                const SpellCheckConfiguration.disabled(),
                            autocorrect: false,
                            enableSuggestions: false,
                            enableInteractiveSelection: true,
                            maxLines: 20,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "Dán nội dung vào đây (Ctrl+V)...",
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Chỉ hiện Loading khi cần
                  if (isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallInput("Dấu giữa Term - Def", termDefSep),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildSmallInput("Dấu giữa các hàng", rowSep)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.paste),
          label: const Text("Dán thủ công"),
          onPressed: isLoading.value ? null : handlePaste,
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: isLoading.value
              ? null
              : () => Navigator.pop(context, {
                  'text': controller.text,
                  'termDef': termDefSep.text,
                  'row': rowSep.text,
                }),
          child: const Text("Phân tích"),
        ),
      ],
    );
  }

  Widget _buildSmallInput(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: "\\t hoặc |"),
        ),
      ],
    );
  }
}

// Intent cho Shortcuts
class _CustomPasteIntent extends Intent {
  const _CustomPasteIntent();
}

class _QuizletExportConfigDialog extends HookWidget {
  const _QuizletExportConfigDialog();

  @override
  Widget build(BuildContext context) {
    final termDefSep = useTextEditingController(text: "\\t");
    final rowSep = useTextEditingController(text: "\\n");

    return AlertDialog(
      title: const Text("Cấu hình định dạng Export"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildField(
            "Dấu giữa Câu hỏi & Đáp án (Term-Def):",
            termDefSep,
            "\\t (Tab)",
          ),
          const SizedBox(height: 16),
          _buildField(
            "Dấu giữa các hàng (Giữa các câu):",
            rowSep,
            "\\n (Xuống dòng)",
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, {
            'termDef': termDefSep.text,
            'row': rowSep.text,
          }),
          style: ElevatedButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text("Sao chép dữ liệu"),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.searchBarBg,
          ),
        ),
      ],
    );
  }
}

class _AddManualQuizDialog extends HookWidget {
  final Function(String) onSave;

  const _AddManualQuizDialog({required this.onSave});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        LibraryStrings.dialogAddQuizTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: LibraryStrings.hintQuizName,
              filled: true,
              fillColor: AppColors.searchBarBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(AppStrings.btnCancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onSave(controller.text.trim());
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: LibraryColors.accentColor,
            foregroundColor: Colors.white,
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(
            AppStrings.btnSave,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
