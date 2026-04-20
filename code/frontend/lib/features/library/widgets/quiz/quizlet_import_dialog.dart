import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuizletImportDialog extends HookWidget {
  const QuizletImportDialog({super.key});

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

      isLoading.value = true;

      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);

        if (data?.text != null && data!.text!.isNotEmpty) {
          // Bước 1: Parse logic
          final processedText = await compute(
            QuizletImportDialog._formatTextHeavy,
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

class _CustomPasteIntent extends Intent {
  const _CustomPasteIntent();
}
