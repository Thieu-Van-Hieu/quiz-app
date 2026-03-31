import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/constants/library_strings.dart';

class SubjectSearch extends HookWidget {
  final Function(String) onSearch;
  const SubjectSearch({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return SearchBar(
      controller: controller,
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: const WidgetStatePropertyAll(LibraryColors.searchBarBg),
      hintText: LibraryStrings.searchHint,
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onSearch,
      leading: const Icon(Icons.search, color: LibraryColors.secondaryText),
    );
  }
}
