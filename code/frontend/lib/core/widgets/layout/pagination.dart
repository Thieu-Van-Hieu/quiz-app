import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/button/button.dart';
import 'package:frontend/core/widgets/dialog/alert_dialog.dart';

class AppPagination extends StatelessWidget {
  final int currentPage; // Chỉ số trang hiện tại (0-indexed)
  final int totalPages; // Tổng số trang
  final ValueChanged<int> onPageChange;
  final Color? activeColor;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
    this.activeColor,
  });

  /// Thuật toán hiển thị thu gọn ở giữa: [1, "...", i-1, i, i+1, "...", totalPages]
  List<dynamic> _generatePageNumbers() {
    List<dynamic> pages = [];
    if (totalPages <= 0) return pages;

    // Luôn luôn hiển thị trang đầu tiên
    pages.add(1);

    // Tính toán khoảng hiển thị xung quanh trang hiện tại (0-indexed sang 1-indexed)
    int current = currentPage + 1;
    int prev = current - 1;
    int next = current + 1;

    // Quản lý dấu ba chấm phía trước
    if (prev > 2) {
      pages.add("...");
    } else if (prev == 2) {
      pages.add(2);
    }

    // Hiển thị trang hiện tại (nếu nó không phải trang đầu hay trang cuối)
    if (current != 1 && current != totalPages) {
      pages.add(current);
    }

    // Quản lý dấu ba chấm phía sau
    if (next < totalPages - 1) {
      pages.add("...");
    } else if (next == totalPages - 1) {
      pages.add(totalPages - 1);
    }

    // Luôn luôn hiển thị trang cuối cùng (nếu tổng số trang > 1)
    if (totalPages > 1) {
      pages.add(totalPages);
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    // Sử dụng màu Xanh Lam Nhạt dịu mắt (Màu Blue/Sky nhẹ nhàng)
    final Color themeColor = activeColor ?? const Color(0xFF3B82F6);
    final List<dynamic> pageList = _generatePageNumbers();

    return Padding(
      // Padding ngoài tạo không gian thở thoáng đãng với lưới câu hỏi phía trên
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment
            .center, // Đảm bảo căn giữa tuyệt đối theo chiều dọc
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- NÚT BACK (Đồng bộ kích thước 40) ---
          _buildNavButton(
            icon: Icons.chevron_left,
            onPressed: currentPage > 0
                ? () => onPageChange(currentPage - 1)
                : null,
            themeColor: themeColor,
          ),
          const SizedBox(width: 6),

          // --- HIỂN THỊ CÁC NÚT SỐ TRANG HOẶC DẤU "..." ---
          ...pageList.map((page) {
            if (page == "...") {
              return const SizedBox(
                width: 32,
                height: 40,
                child: Center(
                  child: Text(
                    "...",
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final int pageIndex = (page as int) - 1;
            final bool isSelected = pageIndex == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onPageChange(pageIndex),
                borderRadius: BorderRadius.circular(12),
                mouseCursor: SystemMouseCursors.click,
                child: Container(
                  width: 40,
                  // Kích thước nút số 40px rõ ràng
                  height: 40,
                  alignment: Alignment.center,
                  // Đưa text vào chính giữa ô vuông
                  decoration: BoxDecoration(
                    color: isSelected ? themeColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? themeColor : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    "$page",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 6),

          // --- NÚT NEXT (Đồng bộ kích thước 40) ---
          _buildNavButton(
            icon: Icons.chevron_right,
            onPressed: currentPage < totalPages - 1
                ? () => onPageChange(currentPage + 1)
                : null,
            themeColor: themeColor,
          ),

          // --- NÚT NHẢY ĐẾN PAGE NHANH (Cố định chiều cao 40) ---
          const SizedBox(width: 8),
          _buildJumpToPageButton(context, themeColor),
        ],
      ),
    );
  }

  /// Hàm dựng nút điều hướng Back/Next đồng bộ chiều cao 40px triệt tiêu hiện tượng lệch dòng
  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color themeColor,
  }) {
    final bool isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      mouseCursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: isDisabled ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  /// Nút bấm phụ cho phép gõ số để nhảy nhanh đến trang bất kỳ (Căn tâm tuyệt đối)
  Widget _buildJumpToPageButton(BuildContext context, Color themeColor) {
    return AppButton(
      onPressed: () async {
        final int? targetPage = await _showJumpDialog(context, themeColor);
        if (targetPage != null && targetPage >= 1 && targetPage <= totalPages) {
          onPageChange(targetPage - 1);
        }
      },
      icon: Icons.directions_run_rounded,
      label: "Đến trang",
      variant: ButtonVariant.indigo,
      size: ButtonSize.small,
    );
  }

  /// ✅ ĐÃ REFACTOR: Sử dụng AppAlertDialog và AppButton hệ thống
  Future<int?> _showJumpDialog(BuildContext context, Color themeColor) {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AppAlertDialog(
        title: "Nhập trang cần đến",
        size: AlertDialogSize.small,
        // Sử dụng kích thước nhỏ gọn cho ô nhập số
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Phạm vi: 1 - $totalPages",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: themeColor, width: 1.5),
              ),
            ),
          ),
        ),
        actions: [
          // Lưu ý: Nút "Hủy" (slate) đã tự động có sẵn từ file AppAlertDialog của bạn rồi!
          // Ở đây ta chỉ cần thêm nút "Đi" với size: ButtonSize.small
          AppButton(
            label: "Đi",
            variant: ButtonVariant
                .brand, // Hoặc variant tương ứng với màu primary của bạn
            size: ButtonSize.small, // Ép cố định size small theo yêu cầu
            onPressed: () {
              final int? val = int.tryParse(controller.text);
              Navigator.pop(context, val);
            },
          ),
        ],
      ),
    );
  }
}
