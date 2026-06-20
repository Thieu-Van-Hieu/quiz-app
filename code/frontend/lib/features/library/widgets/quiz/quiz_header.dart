import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/button.dart';
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

  // Hàm helper xử lý hiển thị Menu chuẩn tọa độ dựa trên vị trí của nút bấm
  void _showImportMenu(BuildContext context) {
    // Tìm tọa độ thực tế của nút trên màn hình để thả menu đúng vị trí
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    // Tính toán khoảng cách (vị trí nút + dịch xuống 52px để không đè lên nút)
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(0, button.size.height + 8),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    // Hiển thị menu tại đúng tọa độ đã tính
    showMenu<int>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        const PopupMenuItem(
          value: 0,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.data_object_rounded),
            title: Text("JSON"),
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.history_toggle_off_rounded),
            title: Text("Binary"),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.auto_awesome_rounded, color: Colors.purple),
            title: Text("Quizlet (Beta)"),
          ),
        ),
      ],
    ).then((val) {
      if (val == null) return;
      if (val == 0) onImport(false);
      if (val == 1) onImport(true);
      if (val == 2) onQuizletImport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- BÊN TRÁI: TIÊU ĐỀ & PHỤ ĐỀ ---
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
            // 1. NÚT IMPORT DẠNG POPUP MENU (Đã fix lỗi lệch vị trí)
            Builder(
              builder: (buttonContext) {
                return AppButton(
                  onPressed: () => _showImportMenu(buttonContext),
                  label: "Nhập",
                  icon: Icons.file_download_outlined,
                  variant: ButtonVariant.slate,
                  size: ButtonSize.medium,
                );
              },
            ),

            const SizedBox(width: 16),

            // 2. NÚT THÊM MỚI (CHỦ ĐẠO BRAND MINT)
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
