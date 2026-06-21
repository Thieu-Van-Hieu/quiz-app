import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';

class QuizletImportDialog extends HookWidget {
  const QuizletImportDialog({super.key});

  static String _formatTextHeavy(String text) {
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

      isLoading.value = true;

      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);

        if (data?.text != null && data!.text!.isNotEmpty) {
          final processedText = await compute(
            QuizletImportDialog._formatTextHeavy,
            data.text!,
          );

          controller.value = TextEditingValue(
            text: processedText.substring(0, 5000),
            selection: const TextSelection.collapsed(offset: 0),
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.value = TextEditingValue(
                text: processedText,
                selection: TextSelection.collapsed(
                  offset: processedText.length,
                ),
              );
            });
          });

          await SchedulerBinding.instance.endOfFrame;
        }
      } catch (e) {
        debugPrint("Lỗi paste: $e");
      } finally {
        isLoading.value = false;
      }
    }

    return AppAlertDialog(
      title: "Nhập từ Quizlet",
      size: AlertDialogSize.medium,
      content: SingleChildScrollView(
        // Bảo vệ dialog khỏi mọi nguy cơ overflow trên các màn hình nhỏ
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          // Giải pháp an toàn: Thiết lập số dòng lớn cố định
                          // Giúp hiển thị ô nhập cực kỳ rộng rãi mà không gây xung đột layout
                          child: AppTextField(
                            label: "Nội dung Quizlet",
                            hintText: "Dán nội dung vào đây (Ctrl+V)...",
                            controller: controller,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
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
                    child: AppTextField(
                      label: "Dấu giữa Term - Def",
                      hintText: "\\t hoặc |",
                      controller: termDefSep,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: "Dấu giữa các hàng",
                      hintText: "\\n hoặc ;",
                      controller: rowSep,
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
                  'text': controller.text,
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
