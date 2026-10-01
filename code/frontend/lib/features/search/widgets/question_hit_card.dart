import 'package:flutter/material.dart';
import 'package:frontend/core/search/text_matcher.dart';
import 'package:frontend/core/widgets/text/highlighted_text.dart';
import 'package:frontend/features/library/constants/library_colors.dart';
import 'package:frontend/features/search/services/master_search_service.dart';

/// 1 kết quả câu hỏi trong Master Search
class QuestionHitCard extends StatelessWidget {
  final QuestionSearchHit hit;
  final TextMatcher matcher;
  final MasterSearchScope scope;
  final VoidCallback onTap;

  const QuestionHitCard({
    super.key,
    required this.hit,
    required this.matcher,
    required this.scope,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final question = hit.question;

    return Material(
      color: LibraryColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LibraryColors.divider, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vị trí: Môn · Bộ đề · Câu N
              Text(
                [
                  if (hit.subject != null) hit.subject!.code,
                  hit.quiz.name,
                  'Câu ${hit.number}',
                ].join('  ·  '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: LibraryColors.secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              HighlightedText(
                question.content,
                matcher: scope.inContent ? matcher : null,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: LibraryColors.primaryText,
                ),
              ),
              const SizedBox(height: 10),
              for (final answer in question.answers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        answer.isCorrect
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_off_rounded,
                        size: 18,
                        color: answer.isCorrect
                            ? LibraryColors.correct
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: HighlightedText(
                          answer.content,
                          matcher:
                              scope.inAnswers &&
                                  (!scope.onlyCorrectAnswers ||
                                      answer.isCorrect)
                              ? matcher
                              : null,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: answer.isCorrect
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (scope.inExplanation && question.explanation.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_rounded,
                      size: 18,
                      color: Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: HighlightedText(
                        question.explanation,
                        matcher: matcher,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
