import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/button/switch.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/dropdown.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/learning_setting.dart';

class LearningSettingDialog extends HookWidget {
  final int totalQuestions;
  final LearningSetting? initialSetting;
  final Function(LearningSetting) onConfirm;

  const LearningSettingDialog({
    super.key,
    required this.totalQuestions,
    this.initialSetting,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Khởi tạo State ban đầu linh hoạt: Ưu tiên dữ liệu cũ được truyền vào
    final settingsNotifier = useValueNotifier(
      initialSetting ??
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

    // 2. Đổ dữ liệu tương ứng lên các Controller điều khiển Input Text
    final fromController = useTextEditingController(
      text: ((initialSetting?.fromIndex ?? 0) + 1)
          .toString(), // Index 0 lưu trong DB hiển thị ra ngoài là Câu 1
    );
    final toController = useTextEditingController(
      text: initialSetting != null
          ? ((initialSetting!.toIndex) + 1).toString()
          : totalQuestions.toString(),
    );
    final timeLimitController = useTextEditingController(
      text: (initialSetting?.customTimeLimit ?? 15).toString(),
    );

    const itemStyle = TextStyle(
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

            // --- DROP DOWN 3D MỘC MẠC ---
            AppDropdown<LearningMode>(
              label: "Chế độ học",
              initialValue: settingsNotifier.value.learningMode,
              items: LearningMode.values.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(m.label, style: itemStyle),
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
                suffixText: "phút",
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
