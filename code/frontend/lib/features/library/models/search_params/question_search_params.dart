import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/core/search/search_options.dart';

part 'question_search_params.mapper.dart';

@MappableClass()
class QuestionSearchParams with QuestionSearchParamsMappable {
  final int quizId;
  final String? keyword; // Chuỗi tìm kiếm cho cả Question và Answer
  final SearchOptions options; // Tuỳ chọn so khớp keyword
  final int size;
  final int page;

  QuestionSearchParams({
    required this.quizId,
    this.keyword,
    this.options = const SearchOptions(),
    this.size = 20,
    this.page = 0,
  });
}
