import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LibraryStrings.detailTitle,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            Text(
              LibraryStrings.detailSubtitle,
              style: TextStyle(
                color: LibraryColors.secondaryText,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildHeaderButton(
              icon: Icons.file_download_outlined,
              label: "Import",
              isOutlined: true,
              onPressed: () {},
              // Thêm rỗng để kích hoạt GestureDetector bên trong
              isPopup: true,
              popupItems: [
                const PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.data_object),
                    title: Text("JSON"),
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Binary"),
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome),
                    title: Text("Quizlet (Beta)"),
                  ),
                ),
              ],
              onPopupSelected: (val) {
                if (val == 0) onImport(false);
                if (val == 1) onImport(true);
                if (val == 2) onQuizletImport();
              },
            ),
            const SizedBox(width: 16),
            _buildHeaderButton(
              icon: Icons.add_rounded,
              label: LibraryStrings.btnAddQuiz,
              onPressed: onAddManual,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isOutlined = false,
    bool isPopup = false,
    List<PopupMenuEntry<int>>? popupItems,
    Function(int)? onPopupSelected,
  }) {
    // 1. Tạo giao diện nút chuẩn
    final buttonContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : LibraryColors.accentColor,
        border: isOutlined
            ? Border.all(
                color: LibraryColors.accentColor.withValues(alpha: 0.5),
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isOutlined ? LibraryColors.accentColor : Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isOutlined ? LibraryColors.accentColor : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    // 2. Xử lý logic Click & Pointer tùy theo loại nút
    if (isPopup) {
      return PopupMenuButton<int>(
        offset: const Offset(0, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onPopupSelected,
        itemBuilder: (ctx) => popupItems!,
        // Dùng MouseRegion bọc ngoài Content bên trong Child của PopupMenu
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: buttonContent,
        ),
      );
    }

    // Nút bình thường
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onPressed, child: buttonContent),
    );
  }
}
