import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/search/search_options.dart';
import 'package:frontend/core/search/text_matcher.dart';

TextMatcher m(
  String query, {
  SearchCaseMode caseMode = SearchCaseMode.smart,
  SearchMatchMode matchMode = SearchMatchMode.contains,
  bool ascii = false,
}) => TextMatcher(
  query,
  SearchOptions(
    caseMode: caseMode,
    matchMode: matchMode,
    ignoreDiacritics: ascii,
  ),
);

/// Lấy các đoạn được highlight để dễ so sánh
List<String> hl(TextMatcher matcher, String text) => matcher
    .findRanges(text)
    .map((r) => text.substring(r.start, r.end))
    .toList();

void main() {
  group('Hoa thường', () {
    test('Smart case: từ khoá thường thì không phân biệt', () {
      expect(m('mác').hasMatch('Chủ nghĩa Mác'), isTrue);
    });

    test('Smart case: từ khoá có chữ hoa thì phân biệt', () {
      expect(m('Mác').hasMatch('chủ nghĩa mác'), isFalse);
      expect(m('Mác').hasMatch('Chủ nghĩa Mác'), isTrue);
    });

    test('Ép phân biệt / không phân biệt', () {
      expect(
        m('mác', caseMode: SearchCaseMode.sensitive).hasMatch('Mác'),
        isFalse,
      );
      expect(m('MÁC', caseMode: SearchCaseMode.ignore).hasMatch('mác'), isTrue);
    });
  });

  group('Bỏ dấu tiếng Việt', () {
    test('Gõ không dấu tìm được chữ có dấu', () {
      final matcher = m('duong loi', ascii: true);
      expect(hl(matcher, 'Đường lối đổi mới'), ['Đường lối']);
    });

    test('Gõ có dấu cũng khớp chữ khác dấu', () {
      expect(m('mặc', ascii: true).hasMatch('Mác'), isTrue);
    });

    test('Văn bản dạng NFD (dấu tổ hợp) vẫn highlight trọn ký tự', () {
      const nfd = 'Việt Nam'; // "Việt Nam" dạng tổ hợp
      expect(hl(m('viet', ascii: true), nfd), ['Việt']);
    });

    test('removeDiacritics', () {
      expect(TextMatcher.removeDiacritics('Đảng Cộng sản'), 'Dang Cong san');
    });
  });

  group('Kiểu khớp', () {
    test('Chứa chuỗi: highlight mọi vị trí', () {
      expect(hl(m('an'), 'Anh, an, ban'), ['An', 'an', 'an']);
    });

    test('Nguyên từ: không khớp giữa từ', () {
      final matcher = m('an', matchMode: SearchMatchMode.wholeWord);
      expect(hl(matcher, 'Anh, an, ban'), ['an']);
    });

    test('Tất cả các từ: không cần theo thứ tự', () {
      final matcher = m('mới đổi', matchMode: SearchMatchMode.allWords);
      expect(matcher.hasMatch('Đường lối đổi mới'), isTrue);
      expect(matcher.hasMatch('Đường lối mới'), isFalse);
      expect(hl(matcher, 'Đường lối đổi mới'), ['đổi', 'mới']);
    });

    test('Tất cả các từ: mỗi từ có thể nằm ở trường khác nhau', () {
      final matcher = m('flutter widget', matchMode: SearchMatchMode.allWords);
      expect(matcher.hasMatchInAny(['Flutter là gì?', 'Widget tree']), isTrue);
      expect(matcher.hasMatchInAny(['Flutter là gì?', 'Dart']), isFalse);
    });

    test('Từng ký tự theo thứ tự', () {
      final matcher = m('cnxh', matchMode: SearchMatchMode.fuzzy);
      expect(matcher.hasMatch('chủ nghĩa xã hội'), isTrue);
      expect(matcher.hasMatch('xã hội chủ nghĩa'), isFalse);
      expect(hl(matcher, 'chủ nghĩa xã hội'), ['c', 'n', 'x', 'h']);
    });

    test('Regex', () {
      final matcher = m(r'\d{4}', matchMode: SearchMatchMode.regex);
      expect(hl(matcher, 'Năm 1945 và 1954'), ['1945', '1954']);
    });

    test('Regex + bỏ dấu', () {
      final matcher = m(
        r'^dang',
        matchMode: SearchMatchMode.regex,
        ascii: true,
        caseMode: SearchCaseMode.ignore,
      );
      expect(hl(matcher, 'Đảng lãnh đạo'), ['Đảng']);
    });

    test('Regex sai cú pháp báo lỗi và không khớp', () {
      final matcher = m('([a-z', matchMode: SearchMatchMode.regex);
      expect(matcher.error, isNotNull);
      expect(matcher.hasMatch('abc'), isFalse);
    });
  });

  test('Từ khoá rỗng khớp tất cả, không highlight', () {
    final matcher = m('  ');
    expect(matcher.hasMatch('bất kỳ'), isTrue);
    expect(matcher.findRanges('bất kỳ'), isEmpty);
  });
}
