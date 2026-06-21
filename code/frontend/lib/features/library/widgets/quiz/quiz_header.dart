import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/input/menu.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class QuizHeader extends StatelessWidget {
  final Function(bool) onImport;
  final VoidCallback onQuizletImport;
  final VoidCallback onAddManual;

  const QuizHeader({
    super.key,
    required this.onImport,
    required this.onQuizletImport,
    required this.onAddManual,
  });

  void _handleMenuOpen(BuildContext context, BuildContext buttonContext) async {
    final selectedValue = await AppMenu.show(
      context: context,
      buttonContext: buttonContext,
      offsetTop: 12.0, // Khoảng cách cách nút bấm 12px
      items: const [
        AppMenuItem(value: 0, label: "JSON", icon: Icons.data_object_rounded),
        AppMenuItem(
          value: 1,
          label: "Binary",
          icon: Icons.history_toggle_off_rounded,
        ),
        AppMenuItem(
          value: 2,
          label: "Quizlet (Beta)",
          icon: Icons.auto_awesome_rounded,
          iconColor: Colors.purple,
        ),
      ],
    );

    if (selectedValue == null) return;
    if (selectedValue == 0) onImport(false);
    if (selectedValue == 1) onImport(true);
    if (selectedValue == 2) onQuizletImport();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- BÊN TRÁI: TIÊU ĐỀ ---
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LibraryStrings.detailTitle,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 4),
            Text(
              LibraryStrings.detailSubtitle,
              style: TextStyle(
                color: LibraryColors.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),

        // --- BÊN PHẢI: CỤM NÚT HÀNH ĐỘNG 3D ---
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (buttonContext) {
                return AppButton(
                  onPressed: () => _handleMenuOpen(
                    context,
                    buttonContext,
                  ), // Hàm hoạt động thật giúp nút luôn sáng màu
                  label: "Import",
                  icon: Icons.file_download_outlined,
                  variant: ButtonVariant.slate,
                  size: ButtonSize.medium,
                );
              },
            ),

            const SizedBox(width: 16),

            AppButton(
              onPressed: onAddManual,
              label: LibraryStrings.btnAddQuiz,
              icon: Icons.add_rounded,
              variant: ButtonVariant.brand,
              size: ButtonSize.medium,
            ),
          ],
        ),
      ],
    );
  }
}
