import 'package:dart_mappable/dart_mappable.dart';

part 'quiz_search_params.mapper.dart';

@MappableClass()
class QuizSearchParams with QuizSearchParamsMappable {
  final int subjectId;
  final String? keyword;
  final int size;
  final int page;

  QuizSearchParams({
    required this.subjectId,
    this.keyword,
    this.size = 10, // Bạn có thể chỉnh size mặc định ở đây
    this.page = 0,
  });
}
