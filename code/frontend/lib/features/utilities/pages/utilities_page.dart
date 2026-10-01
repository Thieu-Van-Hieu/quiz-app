import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/search/data/master_search_repository.dart';
import 'package:frontend/features/utilities/widgets/analysis_tab.dart';
import 'package:frontend/features/utilities/widgets/duplicate_tab.dart';
import 'package:frontend/features/utilities/widgets/merge_tab.dart';
import 'package:frontend/features/utilities/widgets/split_tab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Trang "Công cụ": phân tích / tách / gộp / lọc trùng bộ đề
class UtilitiesPage extends ConsumerWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corpusAsync = ref.watch(watchSearchCorpusProvider);

    return Material(
      color: LibraryColors.background,
      child: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Công cụ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: LibraryColors.primaryText,
                ),
              ),
              const Text(
                "Phân tích, tách, gộp và lọc trùng bộ đề",
                style: TextStyle(color: LibraryColors.secondaryText),
              ),
              const SizedBox(height: 16),
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.textMain,
                indicatorColor: AppColors.brandShadow,
                tabs: [
                  Tab(icon: Icon(Icons.analytics_rounded), text: "Phân tích"),
                  Tab(icon: Icon(Icons.call_split_rounded), text: "Tách quiz"),
                  Tab(icon: Icon(Icons.merge_rounded), text: "Gộp quiz"),
                  Tab(
                    icon: Icon(Icons.content_copy_rounded),
                    text: "Lọc trùng",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: corpusAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) =>
                      Center(child: Text("${AppStrings.error}: $err")),
                  data: (corpus) => TabBarView(
                    children: [
                      AnalysisTab(corpus: corpus),
                      SplitTab(corpus: corpus),
                      MergeTab(corpus: corpus),
                      DuplicateTab(corpus: corpus),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
