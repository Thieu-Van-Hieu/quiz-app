import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/constants/app_strings.dart';
import 'package:frontend/core/search/search_options.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/widgets/input/search_bar.dart';
import 'package:frontend/core/widgets/text/highlighted_text.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/library/models/question_page_args.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/routes/library_routes.dart';
import 'package:frontend/features/search/data/master_search_repository.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/features/search/widgets/question_hit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Tìm kiếm toàn cục trên mọi môn học, bộ đề và câu hỏi
class MasterSearchPage extends HookConsumerWidget {
  const MasterSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyword = useState('');
    final options = useState(const SearchOptions());
    final scope = useState(const MasterSearchScope());

    // Debounce để không phải lọc toàn bộ dữ liệu sau mỗi phím gõ
    final debounceTimer = useRef<Timer?>(null);
    useEffect(
      () =>
          () => debounceTimer.value?.cancel(),
      const [],
    );
    void onSearch(String value) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(
        const Duration(milliseconds: 250),
        () => keyword.value = value,
      );
    }

    final matcher = useMemoized(
      () => TextMatcher(keyword.value, options.value),
      [keyword.value, options.value],
    );

    final corpusAsync = ref.watch(watchSearchCorpusProvider);
    final corpus = corpusAsync.value;

    final result = useMemoized(
      () => corpus == null
          ? const MasterSearchResult()
          : MasterSearchService.search(corpus, matcher, scope.value),
      [corpus, matcher, scope.value],
    );

    void openQuiz(int subjectId, int quizId) {
      context.go(
        LibraryRoutes.getQuizDetailPath(subjectId, quizId),
        extra: QuestionPageArgs(keyword: keyword.value, options: options.value),
      );
    }

    return Material(
      color: LibraryColors.background,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tìm kiếm",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: LibraryColors.primaryText,
              ),
            ),
            const Text(
              "Tìm trên toàn bộ môn học, bộ đề và câu hỏi",
              style: TextStyle(color: LibraryColors.secondaryText),
            ),
            const SizedBox(height: 32),
            AppSearchBar(
              hintText: "Nhập từ khoá...",
              onSearch: onSearch,
              options: options.value,
              onOptionsChanged: (value) => options.value = value,
              error: matcher.error,
            ),
            const SizedBox(height: 16),
            _ScopeBar(
              scope: scope.value,
              onChanged: (value) => scope.value = value,
              subjects: corpus?.subjects ?? const [],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: corpusAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    Center(child: Text("${AppStrings.error}: $err")),
                data: (_) {
                  if (matcher.isEmpty) {
                    return const _Hint("Nhập từ khoá để bắt đầu tìm kiếm");
                  }
                  if (result.isEmpty) {
                    return const _Hint("Không tìm thấy kết quả");
                  }
                  return _ResultList(
                    result: result,
                    matcher: matcher,
                    scope: scope.value,
                    onOpenQuiz: openQuiz,
                    onOpenSubject: (id) =>
                        context.go(LibraryRoutes.getSubjectDetailPath(id)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScopeBar extends StatelessWidget {
  final MasterSearchScope scope;
  final ValueChanged<MasterSearchScope> onChanged;
  final List<Subject> subjects;

  const _ScopeBar({
    required this.scope,
    required this.onChanged,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, bool selected, ValueChanged<bool> onSelected) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        mouseCursor: SystemMouseCursors.click,
        selectedColor: AppColors.brand.withValues(alpha: 0.6),
        checkmarkColor: AppColors.textMain,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Tìm trong:",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: LibraryColors.secondaryText,
          ),
        ),
        chip(
          "Câu hỏi",
          scope.inContent,
          (v) => onChanged(scope.copyWith(inContent: v)),
        ),
        chip(
          "Đáp án",
          scope.inAnswers,
          (v) => onChanged(scope.copyWith(inAnswers: v)),
        ),
        chip(
          "Giải thích",
          scope.inExplanation,
          (v) => onChanged(scope.copyWith(inExplanation: v)),
        ),
        if (scope.inAnswers)
          chip(
            "Chỉ đáp án đúng",
            scope.onlyCorrectAnswers,
            (v) => onChanged(scope.copyWith(onlyCorrectAnswers: v)),
          ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: scope.subjectId,
              hint: const Text("Tất cả môn học"),
              borderRadius: BorderRadius.circular(12),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text("Tất cả môn học"),
                ),
                for (final s in subjects)
                  DropdownMenuItem<int?>(
                    value: s.id,
                    child: Text("${s.code} - ${s.name}"),
                  ),
              ],
              onChanged: (id) => onChanged(scope.copyWith(subjectId: () => id)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultList extends StatelessWidget {
  final MasterSearchResult result;
  final TextMatcher matcher;
  final MasterSearchScope scope;
  final void Function(int subjectId, int quizId) onOpenQuiz;
  final void Function(int subjectId) onOpenSubject;

  const _ResultList({
    required this.result,
    required this.matcher,
    required this.scope,
    required this.onOpenQuiz,
    required this.onOpenSubject,
  });

  @override
  Widget build(BuildContext context) {
    final quizCount = result.questions.map((h) => h.quiz.id).toSet().length;

    Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: LibraryColors.primaryText,
        ),
      ),
    );

    Widget nameChip(String label, VoidCallback onTap) => ActionChip(
      label: HighlightedText(label, matcher: matcher),
      onPressed: onTap,
      mouseCursor: SystemMouseCursors.click,
      backgroundColor: Colors.white,
    );

    return CustomScrollView(
      slivers: [
        if (result.subjects.isNotEmpty || result.quizzes.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (result.subjects.isNotEmpty) ...[
                  sectionTitle("Môn học (${result.subjects.length})"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in result.subjects)
                        nameChip(
                          "${s.code} - ${s.name}",
                          () => onOpenSubject(s.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                if (result.quizzes.isNotEmpty) ...[
                  sectionTitle("Bộ đề (${result.quizzes.length})"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final q in result.quizzes)
                        nameChip(
                          q.name,
                          () => onOpenQuiz(q.subject.targetId, q.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        SliverToBoxAdapter(
          child: sectionTitle(
            "Câu hỏi (${result.questions.length} câu trong $quizCount bộ đề)",
          ),
        ),
        SliverList.separated(
          itemCount: result.questions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final hit = result.questions[index];
            return QuestionHitCard(
              hit: hit,
              matcher: matcher,
              scope: scope,
              onTap: () => onOpenQuiz(hit.quiz.subject.targetId, hit.quiz.id),
            );
          },
        ),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  final String text;

  const _Hint(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: LibraryColors.secondaryText,
          fontSize: 15,
        ),
      ),
    );
  }
}
