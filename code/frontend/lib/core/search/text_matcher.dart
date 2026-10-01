import 'package:frontend/core/search/search_options.dart';

/// Vị trí khớp [start, end) trên chuỗi GỐC (dùng để highlight)
class MatchRange {
  final int start;
  final int end;

  const MatchRange(this.start, this.end);

  @override
  bool operator ==(Object other) =>
      other is MatchRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'MatchRange($start, $end)';
}

/// Chuỗi sau khi chuẩn hoá (hạ chữ thường / bỏ dấu) kèm bảng ánh xạ về vị trí trên chuỗi gốc
class _FoldedText {
  final String value;
  final List<int>
  starts; // starts[i]: vị trí bắt đầu trên chuỗi gốc của ký tự thứ i
  final List<int>
  ends; // ends[i]: vị trí kết thúc trên chuỗi gốc của ký tự thứ i

  _FoldedText(this.value, this.starts, this.ends);

  MatchRange toOriginal(int start, int end) =>
      MatchRange(starts[start], ends[end - 1]);
}

/// Bộ so khớp văn bản dùng chung cho mọi ô tìm kiếm trong app.
/// Từ khoá rỗng được coi là khớp mọi thứ.
class TextMatcher {
  final String query;
  final SearchOptions options;

  late final bool caseSensitive;

  /// Lỗi cú pháp regex (nếu có). Khi có lỗi, matcher không khớp gì cả.
  String? error;

  RegExp? _regex;
  String _needle = '';
  List<String> _terms = const [];

  TextMatcher(this.query, [this.options = const SearchOptions()]) {
    caseSensitive = switch (options.caseMode) {
      SearchCaseMode.sensitive => true,
      SearchCaseMode.ignore => false,
      SearchCaseMode.smart => query != query.toLowerCase(),
    };

    if (isEmpty) return;

    if (options.matchMode == SearchMatchMode.regex) {
      final pattern = options.ignoreDiacritics
          ? _fold(query, lower: false, strip: true).value
          : query;
      try {
        _regex = RegExp(pattern, caseSensitive: caseSensitive, unicode: true);
      } on FormatException catch (e) {
        error = e.message;
      }
      return;
    }

    _needle = _foldText(query.trim()).value;
    _terms = _needle.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
  }

  bool get isEmpty => query.trim().isEmpty;

  /// Văn bản có khớp với từ khoá không
  bool hasMatch(String text) {
    if (isEmpty) return true;
    if (error != null) return false;

    if (options.matchMode == SearchMatchMode.allWords) {
      final folded = _foldText(text).value;
      return _terms.every(folded.contains);
    }
    return findRanges(text).isNotEmpty;
  }

  /// Khớp khi ÍT NHẤT 1 trường khớp.
  /// Riêng chế độ "tất cả các từ": mỗi từ chỉ cần xuất hiện ở 1 trường bất kỳ.
  bool hasMatchInAny(Iterable<String> texts) {
    if (isEmpty) return true;
    if (error != null) return false;

    if (options.matchMode == SearchMatchMode.allWords) {
      final folded = texts.map((t) => _foldText(t).value).toList();
      return _terms.every((term) => folded.any((f) => f.contains(term)));
    }
    return texts.any(hasMatch);
  }

  /// Lọc danh sách theo các trường văn bản của từng phần tử
  List<T> filter<T>(Iterable<T> items, Iterable<String> Function(T) fields) {
    if (isEmpty) return items.toList();
    return items.where((item) => hasMatchInAny(fields(item))).toList();
  }

  /// Các vị trí cần highlight trên chuỗi gốc (đã sắp xếp, không chồng lấn)
  List<MatchRange> findRanges(String text) {
    if (isEmpty || error != null || text.isEmpty) return const [];

    final List<MatchRange> ranges;
    switch (options.matchMode) {
      case SearchMatchMode.regex:
        final folded = _fold(
          text,
          lower: false,
          strip: options.ignoreDiacritics,
        );
        ranges = _regex!
            .allMatches(folded.value)
            .where((m) => m.end > m.start)
            .map((m) => folded.toOriginal(m.start, m.end))
            .toList();
      case SearchMatchMode.contains:
        final folded = _foldText(text);
        ranges = _occurrences(folded, _needle);
      case SearchMatchMode.wholeWord:
        final folded = _foldText(text);
        ranges = _occurrences(folded, _needle, wholeWord: true);
      case SearchMatchMode.allWords:
        final folded = _foldText(text);
        ranges = [for (final term in _terms) ..._occurrences(folded, term)];
      case SearchMatchMode.fuzzy:
        ranges = _fuzzyRanges(_foldText(text));
    }
    return _merge(ranges);
  }

  // --- HELPERS ---

  _FoldedText _foldText(String text) =>
      _fold(text, lower: !caseSensitive, strip: options.ignoreDiacritics);

  List<MatchRange> _occurrences(
    _FoldedText folded,
    String needle, {
    bool wholeWord = false,
  }) {
    if (needle.isEmpty) return const [];
    final haystack = folded.value;
    final result = <MatchRange>[];

    var index = haystack.indexOf(needle);
    while (index != -1) {
      final end = index + needle.length;
      final isWord =
          !wholeWord ||
          ((index == 0 || !_isWordChar(haystack, index - 1)) &&
              (end == haystack.length || !_isWordChar(haystack, end)));
      if (isWord) {
        result.add(folded.toOriginal(index, end));
        index = haystack.indexOf(needle, end);
      } else {
        index = haystack.indexOf(needle, index + 1);
      }
    }
    return result;
  }

  /// Các ký tự của từ khoá (bỏ khoảng trắng) phải xuất hiện lần lượt theo thứ tự
  List<MatchRange> _fuzzyRanges(_FoldedText folded) {
    final chars = _needle.replaceAll(RegExp(r'\s+'), '');
    final haystack = folded.value;
    final result = <MatchRange>[];

    var from = 0;
    for (final char in chars.split('')) {
      final index = haystack.indexOf(char, from);
      if (index == -1) return const [];
      result.add(folded.toOriginal(index, index + 1));
      from = index + 1;
    }
    return result;
  }

  static final _wordCharRegex = RegExp(r'[\p{L}\p{N}_]', unicode: true);

  static bool _isWordChar(String text, int index) =>
      _wordCharRegex.hasMatch(text[index]);

  static List<MatchRange> _merge(List<MatchRange> ranges) {
    if (ranges.length < 2) return ranges;
    final sorted = [...ranges]..sort((a, b) => a.start.compareTo(b.start));
    final merged = <MatchRange>[sorted.first];
    for (final r in sorted.skip(1)) {
      final last = merged.last;
      if (r.start <= last.end) {
        if (r.end > last.end) {
          merged[merged.length - 1] = MatchRange(last.start, r.end);
        }
      } else {
        merged.add(r);
      }
    }
    return merged;
  }

  // --- CHUẨN HOÁ TIẾNG VIỆT ---

  static const _vietnameseGroups = {
    'a': 'àáảãạăằắẳẵặâầấẩẫậ',
    'e': 'èéẻẽẹêềếểễệ',
    'i': 'ìíỉĩị',
    'o': 'òóỏõọôồốổỗộơờớởỡợ',
    'u': 'ùúủũụưừứửữự',
    'y': 'ỳýỷỹỵ',
    'd': 'đ',
    'A': 'ÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬ',
    'E': 'ÈÉẺẼẸÊỀẾỂỄỆ',
    'I': 'ÌÍỈĨỊ',
    'O': 'ÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢ',
    'U': 'ÙÚỦŨỤƯỪỨỬỮỰ',
    'Y': 'ỲÝỶỸỴ',
    'D': 'Đ',
  };

  static final Map<int, String> _asciiMap = {
    for (final entry in _vietnameseGroups.entries)
      for (final rune in entry.value.runes) rune: entry.key,
  };

  /// Bỏ dấu tiếng Việt: "Đường" -> "Duong"
  static String removeDiacritics(String text) =>
      _fold(text, lower: false, strip: true).value;

  // Cache kết quả chuẩn hoá vì cùng 1 chuỗi được so khớp lại mỗi lần gõ phím
  static final _cache = <String, _FoldedText>{};
  static const _maxCacheSize = 100000;

  static _FoldedText _fold(
    String text, {
    required bool lower,
    required bool strip,
  }) {
    if (!lower && !strip) {
      return _FoldedText(
        text,
        List.generate(text.length, (i) => i),
        List.generate(text.length, (i) => i + 1),
      );
    }

    final key = '${lower ? 1 : 0}${strip ? 1 : 0}$text';
    final cached = _cache[key];
    if (cached != null) return cached;

    final buffer = StringBuffer();
    final starts = <int>[];
    final ends = <int>[];

    final iterator = text.runes.iterator;
    while (iterator.moveNext()) {
      final start = iterator.rawIndex;
      final end = start + iterator.currentSize;
      final rune = iterator.current;

      // Dấu tổ hợp (văn bản dạng NFD): bỏ đi và gộp vào ký tự đứng trước
      if (strip && rune >= 0x0300 && rune <= 0x036F) {
        if (ends.isNotEmpty) ends[ends.length - 1] = end;
        continue;
      }

      var piece = (strip ? _asciiMap[rune] : null) ?? String.fromCharCode(rune);
      if (lower) piece = piece.toLowerCase();

      buffer.write(piece);
      for (var i = 0; i < piece.length; i++) {
        starts.add(start);
        ends.add(end);
      }
    }

    final folded = _FoldedText(buffer.toString(), starts, ends);
    if (_cache.length >= _maxCacheSize) _cache.clear();
    _cache[key] = folded;
    return folded;
  }
}
