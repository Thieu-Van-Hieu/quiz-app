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
    // 1. State chính lưu trữ cấu hình
    final settingsNotifier = useValueNotifier(
      initialSetting ??
          LearningSetting(
            fromIndex: 0,
            toIndex: totalQuestions - 1,
            shuffleQuestions: false,
            shuffleOptions: false,
            reviewOffset: 0,
            learningMode: LearningMode.practice,
          ),
    );

    useListenable(settingsNotifier);

    // Mặc định là true nếu initialSetting chưa có hoặc reviewOffset > 0
    final isReviewOffsetEnabled = useState<bool>(
      initialSetting == null ? true : (initialSetting!.reviewOffset > 0),
    );

    // 2. Controllers điều khiển Text Input
    final fromController = useTextEditingController(
      text: ((initialSetting?.fromIndex ?? 0) + 1).toString(),
    );
    final toController = useTextEditingController(
      text: initialSetting != null
          ? ((initialSetting!.toIndex) + 1).toString()
          : totalQuestions.toString(),
    );
    final timeLimitController = useTextEditingController(
      text: (initialSetting?.customTimeLimit ?? 15).toString(),
    );
    final reviewOffsetController = useTextEditingController(
      text:
          ((initialSetting?.reviewOffset ?? 0) > 0
                  ? initialSetting!.reviewOffset
                  : 5)
              .toString(),
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

            // --- CHẾ ĐỘ HỌC ---
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

            // --- THỜI GIAN THI (CHỈ HIỆN KHI CHỌN MODE EXAM) ---
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

            // --- KHOẢNG CÂU HỌC ---
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

            // --- NHÓM CÁC CẤU HÌNH SWITCH & OFFSET ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppSwitch(
                    label: "Đảo câu",
                    value: settingsNotifier.value.shuffleQuestions,
                    onChanged: (v) => settingsNotifier.value = settingsNotifier
                        .value
                        .copyWith(shuffleQuestions: v),
                  ),
                ),
                Expanded(
                  child: AppSwitch(
                    label: "Đảo đáp án",
                    value: settingsNotifier.value.shuffleOptions,
                    onChanged: (v) => settingsNotifier.value = settingsNotifier
                        .value
                        .copyWith(shuffleOptions: v),
                  ),
                ),
                Expanded(
                  child: AppSwitch(
                    label: "Lặp câu sai",
                    value: isReviewOffsetEnabled.value,
                    onChanged: (v) => isReviewOffsetEnabled.value = v,
                  ),
                ),

                // Ô nhập khoảng cách lặp lại (reviewOffset)
                AppTextField(
                  controller: reviewOffsetController,
                  enabled: isReviewOffsetEnabled.value,
                  layoutDirection: Axis.horizontal,
                  textFieldWidth: 80,
                  label: "Khoảng cách",
                  hintText: "3",
                  keyboardType: TextInputType.number,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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

            // Tính toán reviewOffset dựa trên Switch
            int finalReviewOffset = 0;
            if (isReviewOffsetEnabled.value) {
              final parsed = int.tryParse(reviewOffsetController.text) ?? 3;
              finalReviewOffset = parsed > 0 ? parsed : 3;
            }

            onConfirm(
              settingsNotifier.value.copyWith(
                fromIndex: from - 1,
                toIndex: to - 1,
                reviewOffset: finalReviewOffset,
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
