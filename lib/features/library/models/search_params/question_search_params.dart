import 'package:dart_mappable/dart_mappable.dart';

part 'question_search_params.mapper.dart';

@MappableClass()
class QuestionSearchParams with QuestionSearchParamsMappable {
  final int quizId;
  final String? keyword; // Chuỗi tìm kiếm cho cả Question và Answer
  final int size;
  final int page;

  QuestionSearchParams({
    required this.quizId,
    this.keyword,
    this.size = 20,
    this.page = 0,
  });
}
