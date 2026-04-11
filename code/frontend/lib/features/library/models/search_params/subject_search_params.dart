import 'package:dart_mappable/dart_mappable.dart';

part 'subject_search_params.mapper.dart';

@MappableClass()
class SubjectSearchParams with SubjectSearchParamsMappable {
  final String? keyword;
  final int size;
  final int page;

  SubjectSearchParams({
    this.keyword,
    this.size = 10, // Bạn có thể chỉnh size mặc định ở đây
    this.page = 0,
  });
}
