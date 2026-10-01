import 'package:flutter/material.dart';
import 'package:frontend/core/search/text_matcher.dart';

/// Text có highlight các đoạn khớp với từ khoá tìm kiếm
class HighlightedText extends StatelessWidget {
  final String text;
  final TextMatcher? matcher;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  static const defaultHighlightColor = Color(0xFFFDE68A); // Vàng nhạt dễ đọc

  const HighlightedText(
    this.text, {
    super.key,
    this.matcher,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final ranges = matcher?.findRanges(text) ?? const <MatchRange>[];
    if (ranges.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final effectiveHighlight =
        highlightStyle ??
        const TextStyle(
          backgroundColor: defaultHighlightColor,
          color: Color(0xFF0F172A),
        );

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final range in ranges) {
      if (range.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: text.substring(range.start, range.end),
          style: effectiveHighlight,
        ),
      );
      cursor = range.end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));

    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
