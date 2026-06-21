import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/button/switch.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
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

    // Lắng nghe sự thay đổi của notifier để trigger rebuild khi cần
    useListenable(settingsNotifier);

    final fromController = useTextEditingController(text: '1');
    final toController = useTextEditingController(
      text: totalQuestions.toString(),
    );
    final timeLimitController = useTextEditingController(text: '15');

    const labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontSize: 14,
    );

    return AppAlertDialog(
      title: "Cấu hình học tập",
      size: AlertDialogSize.medium,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            DropdownButtonFormField<LearningMode>(
              value: settingsNotifier.value.learningMode,
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
                if (val != null) {
                  settingsNotifier.value = settingsNotifier.value.copyWith(
                    learningMode: val,
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            if (settingsNotifier.value.learningMode == LearningMode.exam) ...[
              AppTextField(
                label: "Thời gian thi (phút)",
                hintText: "Nhập số phút",
                prefixText: "phút",
                controller: timeLimitController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
            ],

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: "Từ câu",
                    hintText: "Min: 1",
                    controller: fromController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    label: "Đến câu",
                    hintText: "Max: $totalQuestions",
                    controller: toController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppSwitch(
                  label: "Đảo câu hỏi",
                  value: settingsNotifier.value.shuffleQuestions,
                  onChanged: (v) => settingsNotifier.value = settingsNotifier
                      .value
                      .copyWith(shuffleQuestions: v),
                ),
                AppSwitch(
                  label: "Đảo đáp án",
                  value: settingsNotifier.value.shuffleOptions,
                  onChanged: (v) => settingsNotifier.value = settingsNotifier
                      .value
                      .copyWith(shuffleOptions: v),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: "Bắt đầu",
          variant: ButtonVariant.indigo,
          size: ButtonSize.small,
          onPressed: () {
            int from = int.tryParse(fromController.text) ?? 1;
            int to = int.tryParse(toController.text) ?? totalQuestions;

            if (from > to) {
              final temp = from;
              from = to;
              to = temp;
            }

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
        ),
      ],
    );
  }
}
