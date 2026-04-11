import 'package:frontend/core/exceptions/app_exception.dart'; // chứa EntityNotFoundException
import 'package:frontend/core/extensions/condition_extension.dart';
import 'package:frontend/core/extensions/list_extension.dart';
import 'package:frontend/core/extensions/query_builder_extension.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/question_search_params.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_repository.g.dart';

@riverpod
QuestionRepository questionRepository(Ref ref) {
  return QuestionRepository();
}

class QuestionRepository {
  final _questionBox = ObjectBoxService.instance.get<Question>();
  final _quizBox = ObjectBoxService.instance.get<Quiz>();

  /// 1. Theo dõi danh sách câu hỏi của một Quiz (Real-time)
  /// Watch danh sách có lọc và phân trang

  Stream<List<Question>> watchQuestions(QuestionSearchParams params) {
    // Lắng nghe sự thay đổi từ cả 2 bảng Question và Answer
    // Lưu ý: Nếu không dùng rxdart, bạn có thể lắng nghe questionBox nhưng
    // chấp nhận rủi ro khi Answer thay đổi thì UI không update ngay.

    return _questionBox.query().watch(triggerImmediately: true).map((_) {
      // 1. Khởi tạo QueryBuilder (Chưa build)
      final questionContentQb = _questionBox.query(
        Question_.quiz
            .equals(params.quizId)
            .safeAnd(params.keyword, Question_.content.contains),
      );

      final answerContentQb = _questionBox.query(
        Question_.quiz.equals(params.quizId),
      );
      answerContentQb.safeBacklink(
        params.keyword,
        Answer_.question,
        Answer_.content.contains,
      );

      // 2. Build và thực thi
      final questionContentIds = questionContentQb.getIdsAndClose();
      final answerContentIds = answerContentQb.getIdsAndClose();
      final combineIds = {...questionContentIds, ...answerContentIds}.toList();

      final pagedIds = combineIds.paged(params.page, params.size);
      return _questionBox.getMany(pagedIds).whereType<Question>().toList();
    });
  }

  /// 2. Lấy danh sách câu hỏi theo Quiz (Async)
  Future<List<Question>> getQuestionsByQuiz(int quizId) async {
    final query = _questionBox.query(Question_.quiz.equals(quizId)).build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  /// 3. Lấy câu hỏi theo ID
  Future<Question?> getQuestionById(int id) {
    return _questionBox.getAsync(id);
  }

  /// 4. Lưu hoặc cập nhật câu hỏi
  Future<void> saveQuestion(int quizId, Question question) async {
    final quiz = await _quizBox.getAsync(quizId);
    if (quiz == null) {
      throw EntityNotFoundException('Quiz không tồn tại.');
    }
    question.quiz.target = quiz;
    await _questionBox.putAsync(question);
  }

  /// 5. Xóa một câu hỏi
  Future<void> deleteQuestion(int questionId) async {
    final success = await _questionBox.removeAsync(questionId);
    if (!success) {
      throw EntityNotFoundException('Câu hỏi không tồn tại hoặc đã bị xóa.');
    }
  }

  /// 6. Xóa tất cả câu hỏi của một Quiz (Batch Delete)
  Future<void> deleteQuestionsByQuiz(int quizId) async {
    final query = _questionBox.query(Question_.quiz.equals(quizId)).build();
    await query.removeAsync();
    query.close();
  }
}
