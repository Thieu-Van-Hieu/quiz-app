// lib/features/learning/widgets/eos_header.dart
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/learning/widgets/eos/header_info.dart';
import 'package:frontend/features/learning/widgets/eos/national_flag.dart';
import 'package:frontend/features/learning/widgets/retro/dropdown.dart';
import 'package:frontend/features/learning/widgets/retro/number_input.dart';

class EosHeader extends StatelessWidget {
  final Map<String, String> info;
  final ValueNotifier<double> fontSizeNotifier;
  final ValueNotifier<String> fontFamilyNotifier;
  final Widget clockWidget;

  const EosHeader({
    super.key,
    required this.info,
    required this.fontSizeNotifier,
    required this.fontFamilyNotifier,
    required this.clockWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: info.entries
                  .map(
                    (entry) => HeaderInfo(label: entry.key, value: entry.value),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Font: ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    RetroDropdown<String>(
                      initValue: fontFamilyNotifier.value,
                      items: AppStrings.fonts
                          .map(
                            (font) => DropdownMenuItem(
                              value: font,
                              child: Text(
                                font,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => fontFamilyNotifier.value =
                          v ?? fontFamilyNotifier.value,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Size: ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    RetroNumberInput(
                      valueNotifier: fontSizeNotifier,
                      minValue: 8,
                      maxValue: 30,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NationalFlag(),
                    const SizedBox(width: 8),
                    clockWidget,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
