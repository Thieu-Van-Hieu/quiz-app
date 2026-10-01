import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/core/search/search_options.dart';

part 'learning_session_search_params.mapper.dart';

@MappableClass(
  generateMethods:
      GenerateMethods.copy | GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
class LearningSessionSearchParams with LearningSessionSearchParamsMappable {
  final int? quizId;
  final String? mode;
  final String? keyword;
  final SearchOptions options; // Tuỳ chọn so khớp keyword
  final bool? isCompleted;
  final int size;
  final int page;

  LearningSessionSearchParams({
    this.quizId,
    this.mode,
    this.keyword,
    this.options = const SearchOptions(),
    this.isCompleted,
    this.size = 10, // Mặc định lấy 20 bản ghi mỗi trang
    this.page = 0,
  });
}
