import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:re_editor/re_editor.dart';

class QuizletImportDialog extends HookWidget {
  const QuizletImportDialog({super.key});

  static String _formatTextHeavy(String text) {
    return text.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller của re_editor
    final editorController = useMemoized(() => CodeLineEditingController());
    final termDefSep = useTextEditingController(text: "\\t");
    final rowSep = useTextEditingController(text: "\\n");
    final isLoading = useState<bool>(false);

    // Hàm xử lý Paste từ Clipboard
    Future<void> handlePaste() async {
      if (isLoading.value) return;

      isLoading.value = true;
      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);

        if (data?.text != null && data!.text!.isNotEmpty) {
          final processedText = await compute(
            QuizletImportDialog._formatTextHeavy,
            data.text!,
          );

          editorController.text = processedText;
          await SchedulerBinding.instance.endOfFrame;
        }
      } catch (e) {
        debugPrint("Lỗi paste: $e");
      } finally {
        isLoading.value = false;
      }
    }

    // Hàm xử lý Chọn file Text từ thiết bị
    Future<void> handlePickFile() async {
      if (isLoading.value) return;

      try {
        final result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['txt', 'csv', 'tsv', 'json'],
          withData: true, // Lấy bytes để hỗ trợ cả Flutter Web & Desktop/Mobile
        );

        if (result != null && result.files.isNotEmpty) {
          isLoading.value = true;

          final fileBytes = result.files.first.bytes;
          if (fileBytes != null) {
            // Decode utf8 dữ liệu từ file
            final rawText = utf8.decode(fileBytes);

            final processedText = await compute(
              QuizletImportDialog._formatTextHeavy,
              rawText,
            );

            editorController.text = processedText;
            await SchedulerBinding.instance.endOfFrame;
          }
        }
      } catch (e) {
        debugPrint("Lỗi đọc file: $e");
      } finally {
        isLoading.value = false;
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final editorHeight = (screenHeight * 0.6).clamp(200.0, 600.0);

    return AppAlertDialog(
      title: "Nhập từ Quizlet / File Text",
      size: AlertDialogSize.big,
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
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
                          child: Container(
                            height: editorHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFFFAFAFA),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CodeEditor(
                                controller: editorController,
                                style: const CodeEditorStyle(
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                  textColor: Colors.black87,
                                ),
                                indicatorBuilder: null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isLoading.value)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: termDefSep,
                      decoration: const InputDecoration(
                        labelText: "Dấu giữa Term - Def",
                        hintText: "\\t hoặc |",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: rowSep,
                      decoration: const InputDecoration(
                        labelText: "Dấu giữa các hàng",
                        hintText: "\\n hoặc ;",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          label: "Chọn file (.txt)",
          variant: ButtonVariant.indigo,
          size: ButtonSize.small,
          onPressed: isLoading.value ? null : handlePickFile,
        ),
        AppButton(
          label: "Dán thủ công",
          variant: ButtonVariant.indigo,
          size: ButtonSize.small,
          onPressed: isLoading.value ? null : handlePaste,
        ),
        AppButton(
          label: "Phân tích",
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          onPressed: isLoading.value
              ? null
              : () => Navigator.pop(context, {
                  'text': editorController.text,
                  'termDef': termDefSep.text,
                  'row': rowSep.text,
                }),
        ),
      ],
    );
  }
}

class _CustomPasteIntent extends Intent {
  const _CustomPasteIntent();
}
