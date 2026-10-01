import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/core/search/search_options.dart';

part 'subject_search_params.mapper.dart';

@MappableClass()
class SubjectSearchParams with SubjectSearchParamsMappable {
  final String? keyword;
  final SearchOptions options; // Tuỳ chọn so khớp keyword
  final int size;
  final int page;

  SubjectSearchParams({
    this.keyword,
    this.options = const SearchOptions(),
    this.size = 10, // Bạn có thể chỉnh size mặc định ở đây
    this.page = 0,
  });
}
