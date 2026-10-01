import 'package:frontend/core/search/search_options.dart';

/// Tham số truyền qua `extra` của go_router khi mở QuestionPage
/// (vd. từ Master Search để mở sẵn từ khoá tìm kiếm)
class QuestionPageArgs {
  final String keyword;
  final SearchOptions options;

  const QuestionPageArgs({
    required this.keyword,
    this.options = const SearchOptions(),
  });
}
