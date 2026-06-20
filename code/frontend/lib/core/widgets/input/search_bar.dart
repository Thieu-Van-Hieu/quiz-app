import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppSearchBar extends HookWidget {
  final String hintText;
  final Function(String) onSearch;
  final double maxWidth;

  const AppSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = "Tìm kiếm...", // Mặc định nếu không truyền
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SearchBar(
        controller: controller,
        // Ép nó dài hết cái maxWidth đã cho
        constraints: BoxConstraints(
          // KHÔNG dùng double.infinity ở minWidth nữa
          minWidth: 324.0, // Để nó có một cái sàn (Floor) tối thiểu
          maxWidth: maxWidth, // Dùng cái trần (Ceiling) phen truyền vào
          minHeight: 50.0,
        ),
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: const WidgetStatePropertyAll(AppColors.searchBarBg),
        hintText: hintText,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onSearch,
        leading: const Icon(Icons.search, color: AppColors.secondaryText),
        // Thêm nút X để xóa nhanh text cho chuyên nghiệp
        trailing: [
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller.clear();
                onSearch('');
              },
            ),
        ],
      ),
    );
  }
}
