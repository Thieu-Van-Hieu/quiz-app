import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/learning_setting.dart';

class LearningSettingDialog extends HookWidget {
  final int totalQuestions;
  final Function(LearningSetting) onConfirm;

  const LearningSettingDialog({
    super.key,
    required this.totalQuestions,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // Gom tất cả state vào một ValueNotifier duy nhất
    final settingsNotifier = useValueNotifier(
      LearningSetting(
        fromIndex: 0,
        toIndex: totalQuestions - 1,
        shuffleQuestions: false,
        shuffleOptions: false,
        learningMode: LearningMode.practice,
      ),
    );

    // Lắng nghe sự thay đổi của notifier để trigger rebuild khi cần (ví dụ ẩn/hiện ô nhập thời gian)
    useListenable(settingsNotifier);

    final fromController = useTextEditingController(text: '1');
    final toController = useTextEditingController(
      text: totalQuestions.toString(),
    );
    final timeLimitController = useTextEditingController(text: '15');

    void updateController(
      TextEditingController controller,
      String value,
      int max,
    ) {
      if (value.isEmpty) return;
      final intValue = int.tryParse(value) ?? 1;
      String newValue = value;
      if (intValue < 1) newValue = "1";
      if (intValue > max) newValue = max.toString();

      if (controller.text != newValue) {
        controller.text = newValue;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    }

    const labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontSize: 14,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Cấu hình học tập",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<LearningMode>(
                initialValue: settingsNotifier.value.learningMode,
                decoration: const InputDecoration(
                  labelText: "Chế độ",
                  labelStyle: labelStyle,
                  border: OutlineInputBorder(),
                ),
                items: LearningMode.values.map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m.label, style: labelStyle),
                  );
                }).toList(),
                onChanged: (val) {
                  settingsNotifier.value = settingsNotifier.value.copyWith(
                    learningMode: val!,
                  );
                },
              ),
              const SizedBox(height: 20),

              if (settingsNotifier.value.learningMode == LearningMode.exam) ...[
                TextField(
                  controller: timeLimitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Thời gian thi (phút)",
                    labelStyle: labelStyle,
                    suffixText: "phút",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: fromController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) =>
                          updateController(fromController, v, totalQuestions),
                      decoration: const InputDecoration(
                        labelText: "Từ câu",
                        helperText: "Min: 1",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: toController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) =>
                          updateController(toController, v, totalQuestions),
                      decoration: InputDecoration(
                        labelText: "Đến câu",
                        helperText: "Max: $totalQuestions",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCompactSwitch(
                    "Đảo câu hỏi",
                    settingsNotifier.value.shuffleQuestions,
                    (v) => settingsNotifier.value = settingsNotifier.value
                        .copyWith(shuffleQuestions: v),
                  ),
                  _buildCompactSwitch(
                    "Đảo đáp án",
                    settingsNotifier.value.shuffleOptions,
                    (v) => settingsNotifier.value = settingsNotifier.value
                        .copyWith(shuffleOptions: v),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          // Thêm Cursor Pointer cho nút Hủy
          style: TextButton.styleFrom(
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          child: const Text(
            "Hủy",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledMouseCursor: SystemMouseCursors.click,
          ),
          onPressed: () {
            int from = int.tryParse(fromController.text) ?? 1;
            int to = int.tryParse(toController.text) ?? totalQuestions;

            if (from > to) {
              final temp = from;
              from = to;
              to = temp;
            }

            // Gửi dữ liệu cuối cùng từ Notifier kết hợp với các Controller
            onConfirm(
              settingsNotifier.value.copyWith(
                fromIndex: from - 1,
                toIndex: to - 1,
                customTimeLimit:
                    settingsNotifier.value.learningMode == LearningMode.exam
                    ? int.tryParse(timeLimitController.text)
                    : null,
              ),
            );
            Navigator.pop(context);
          },
          child: const Text(
            "Bắt đầu",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactSwitch(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.deepPurple,
            mouseCursor: SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }
}
