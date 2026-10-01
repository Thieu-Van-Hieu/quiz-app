import 'package:dart_mappable/dart_mappable.dart';

part 'search_options.mapper.dart';

/// Cách xử lý chữ hoa/thường khi tìm kiếm
@MappableEnum()
enum SearchCaseMode {
  /// Tự động: phân biệt hoa thường nếu từ khoá có chữ hoa
  smart("Tự động (phân biệt nếu từ khoá có chữ hoa)"),
  ignore("Không phân biệt hoa thường"),
  sensitive("Phân biệt hoa thường");

  final String label;

  const SearchCaseMode(this.label);
}

/// Cách so khớp từ khoá
@MappableEnum()
enum SearchMatchMode {
  contains("Chứa chuỗi"),
  wholeWord("Khớp nguyên từ"),
  allWords("Chứa tất cả các từ (không cần theo thứ tự)"),
  fuzzy("Khớp theo từng ký tự (các ký tự xuất hiện theo thứ tự)"),
  regex("Biểu thức chính quy (Regex)");

  final String label;

  const SearchMatchMode(this.label);
}

@MappableClass()
class SearchOptions with SearchOptionsMappable {
  final SearchCaseMode caseMode;
  final SearchMatchMode matchMode;

  /// Chuẩn hoá tiếng Việt về ASCII (bỏ dấu, đ -> d) trước khi so khớp
  final bool ignoreDiacritics;

  const SearchOptions({
    this.caseMode = SearchCaseMode.smart,
    this.matchMode = SearchMatchMode.contains,
    this.ignoreDiacritics = false,
  });
}
