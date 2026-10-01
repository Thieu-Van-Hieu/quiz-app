import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/search/search_options.dart';

/// Cụm nút tuỳ chọn tìm kiếm (kiểu VSCode) đặt trong ô tìm kiếm
class SearchOptionToggles extends StatelessWidget {
  final SearchOptions options;
  final ValueChanged<SearchOptions> onChanged;

  /// Lỗi cú pháp regex, hiện icon cảnh báo kèm tooltip
  final String? error;

  const SearchOptionToggles({
    super.key,
    required this.options,
    required this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    // Chọn lại chế độ đang bật thì quay về "Chứa chuỗi"
    void toggleMode(SearchMatchMode mode) {
      onChanged(
        options.copyWith(
          matchMode: options.matchMode == mode
              ? SearchMatchMode.contains
              : mode,
        ),
      );
    }

    final caseLabel = switch (options.caseMode) {
      SearchCaseMode.smart => 'aA',
      SearchCaseMode.sensitive => 'Aa',
      SearchCaseMode.ignore => 'aa',
    };
    final nextCaseMode = SearchCaseMode
        .values[(options.caseMode.index + 1) % SearchCaseMode.values.length];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (error != null)
          Tooltip(
            message: 'Regex không hợp lệ: $error',
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        _OptionButton(
          label: caseLabel,
          tooltip:
              '${options.caseMode.label}\nBấm để chuyển: ${nextCaseMode.label}',
          isActive: options.caseMode != SearchCaseMode.smart,
          onTap: () => onChanged(options.copyWith(caseMode: nextCaseMode)),
        ),
        _OptionButton(
          label: 'Ă→A',
          tooltip: 'Bỏ dấu tiếng Việt khi so khớp (đ → d)',
          isActive: options.ignoreDiacritics,
          onTap: () => onChanged(
            options.copyWith(ignoreDiacritics: !options.ignoreDiacritics),
          ),
        ),
        const SizedBox(width: 4),
        _modeButton('ab', SearchMatchMode.wholeWord, toggleMode),
        _modeButton('&', SearchMatchMode.allWords, toggleMode),
        _modeButton('a…z', SearchMatchMode.fuzzy, toggleMode),
        _modeButton('.*', SearchMatchMode.regex, toggleMode),
      ],
    );
  }

  Widget _modeButton(
    String label,
    SearchMatchMode mode,
    void Function(SearchMatchMode) toggleMode,
  ) {
    return _OptionButton(
      label: label,
      tooltip: mode.label,
      isActive: options.matchMode == mode,
      onTap: () => toggleMode(mode),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final String tooltip;
  final bool isActive;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.tooltip,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          constraints: const BoxConstraints(minWidth: 30),
          height: 28,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.brandShadow.withValues(alpha: 0.18)
                : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.brandShadow : Colors.transparent,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isActive ? AppColors.textMain : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
