import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';
import 'package:frontend/core/widgets/input/dropdown.dart';
import 'package:frontend/core/widgets/input/text_field.dart';
import 'package:frontend/features/library/models/subject.dart';

/// Giá trị dropdown đại diện cho "Tạo môn mới"
const int _newSubjectValue = -1;

typedef ImportSubmit =
    Future<void> Function({
      int? subjectId,
      String? newSubjectCode,
      required String quizName,
    });

/// Chọn môn học + đặt tên bộ đề trước khi lưu. Dialog tự lưu qua [onSubmit]
/// và giữ nguyên nếu lỗi (vd. trùng tên) để người dùng sửa ngay.
/// Trả về true nếu đã lưu thành công.
class ImportRemoteDialog extends HookWidget {
  final String subjectCode;
  final String initialName;
  final int questionCount;
  final List<Subject> subjects;
  final ImportSubmit onSubmit;

  const ImportRemoteDialog({
    super.key,
    required this.subjectCode,
    required this.initialName,
    required this.questionCount,
    required this.subjects,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final matched = subjects
        .where((s) => s.code.toLowerCase() == subjectCode.toLowerCase())
        .firstOrNull;
    final selected = useState<int>(matched?.id ?? _newSubjectValue);
    final nameController = useTextEditingController(text: initialName);
    final codeController = useTextEditingController(text: subjectCode);
    final error = useState<String?>(null);
    final isSaving = useState(false);

    final sortedSubjects = [...subjects]
      ..sort((a, b) => a.code.compareTo(b.code));

    Future<void> submit() async {
      error.value = null;
      final isNew = selected.value == _newSubjectValue;
      if (isNew && codeController.text.trim().isEmpty) {
        error.value = 'Mã môn học không được để trống.';
        return;
      }
      isSaving.value = true;
      try {
        await onSubmit(
          subjectId: isNew ? null : selected.value,
          newSubjectCode: isNew ? codeController.text.trim() : null,
          quizName: nameController.text,
        );
        if (context.mounted) Navigator.pop(context, true);
      } on AppException catch (e) {
        error.value = e.message;
      } catch (e) {
        error.value = 'Không lưu được bộ đề: $e';
      } finally {
        if (context.mounted) isSaving.value = false;
      }
    }

    return AppAlertDialog(
      title: 'Import bộ đề ($questionCount câu)',
      size: AlertDialogSize.small,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDropdown<int>(
            label: 'Lưu vào môn học',
            initialValue: selected.value,
            items: [
              DropdownMenuItem(
                value: _newSubjectValue,
                child: Text('+ Tạo môn mới'),
              ),
              for (final s in sortedSubjects)
                DropdownMenuItem(
                  value: s.id,
                  child: Text(
                    s.name.isEmpty || s.name == s.code
                        ? s.code
                        : '${s.code} · ${s.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: (v) => selected.value = v ?? _newSubjectValue,
          ),
          if (selected.value == _newSubjectValue) ...[
            const SizedBox(height: 16),
            AppTextField(label: 'Mã môn mới', controller: codeController),
          ],
          const SizedBox(height: 16),
          AppTextField(label: 'Tên bộ đề', controller: nameController),
          if (error.value != null) ...[
            const SizedBox(height: 12),
            Text(
              error.value!,
              style: const TextStyle(
                color: AppColors.actionDeleteShadow,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
      actions: [
        AppButton(
          label: 'Hủy',
          variant: ButtonVariant.slateOutlined,
          size: ButtonSize.small,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          label: 'Lưu bộ đề',
          icon: Icons.save_alt_rounded,
          variant: ButtonVariant.brand,
          size: ButtonSize.small,
          isLoading: isSaving.value,
          onPressed: isSaving.value ? null : submit,
        ),
      ],
    );
  }
}
