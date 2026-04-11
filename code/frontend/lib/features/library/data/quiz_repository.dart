import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/extensions/condition_extension.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/search_params/quiz_search_params.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_repository.g.dart';

@riverpod
QuizRepository quizRepository(Ref ref) {
  return QuizRepository();
}

class QuizRepository {
  final _db = ObjectBoxService.instance;
  final _quizBox = ObjectBoxService.instance.get<Quiz>();
  final _subjectBox = ObjectBoxService.instance.get<Subject>();

  /// 1. Theo dõi tất cả Quiz của một Subject (Real-time)
  Stream<List<Quiz>> watchAllQuizzes(int subjectId) {
    return _quizBox
        .query(Quiz_.subject.equals(subjectId))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Condition<Quiz>? getSearchParamsCondition(QuizSearchParams params) {
    Condition<Quiz>? condition;
    return condition
        .safeAnd(params.subjectId, Quiz_.subject.equals)
        .safeAnd(
          params.keyword,
          (value) => Quiz_.name.contains(value, caseSensitive: false),
        );
  }

  Stream<List<Quiz>> watchQuizzes(QuizSearchParams params) {
    return _quizBox
        .query(
          // Quiz_.subject
          //     .equals(params.subjectId)
          //     .safeAnd(params.keyword, Quiz_.name.contains),
          getSearchParamsCondition(params),
        )
        .watch(triggerImmediately: true)
        .map(((query) {
          query.offset = params.page * params.size;
          query.limit = params.size;

          // Lúc này find() sẽ trả về đúng số lượng đã phân trang
          return query.find();
        }));
  }

  Stream<Quiz?> watchQuiz(int id) {
    return _quizBox
        .query(Quiz_.id.equals(id))
        .watch(triggerImmediately: true)
        .map(((query) => query.findFirst()));
  }

  Stream<int> watchTotalPages(QuizSearchParams params) {
    return _quizBox
        .query(getSearchParamsCondition(params))
        .watch(triggerImmediately: true)
        .map((query) {
          final totalCount = query.count();
          if (totalCount == 0) return 1;
          return (totalCount / params.size).ceil();
        });
  }

  /// 2. Lấy Quiz theo ID
  Future<Quiz?> getQuizById(int id) {
    return _quizBox.getAsync(id);
  }

  /// 3. Lấy Quiz theo SubjectId và Tên (Query kết hợp)
  Future<Quiz?> getQuizBySubjectIdAndName(int subjectId, String name) async {
    final query = _quizBox
        .query(Quiz_.subject.equals(subjectId).and(Quiz_.name.equals(name)))
        .build();

    final result = await query.findFirstAsync();
    query.close();
    return result;
  }

  /// 4. Cập nhật danh sách câu hỏi của Quiz (Upsert logic)
  /// 4. Cập nhật danh sách câu hỏi của Quiz (Upsert logic)
  Future<void> updateQuizQuestions(int quizId, List<Question> questions) async {
    final quiz = await _quizBox.getAsync(quizId);
    if (quiz == null) {
      throw EntityNotFoundException('Quiz không tồn tại.');
    }

    await _db.store.runInTransactionAsync(TxMode.write, (
      Store store,
      List<dynamic> params,
    ) {
      final qId = params[0] as int;
      final newQuestions = params[1] as List<Question>;

      final internalQuizBox = store.box<Quiz>();
      final internalQuestionBox = store.box<Question>();

      final currentQuiz = internalQuizBox.get(qId);
      if (currentQuiz == null) return;

      for (var q in newQuestions) {
        q.quiz.target = currentQuiz;
        // Tự động đồng bộ quan hệ nội bộ của Question
        q.syncAnswers();
      }

      // Chỉ cần put Question, ObjectBox sẽ tự động put các Answer trong ToMany
      internalQuestionBox.putMany(newQuestions);

      // Cập nhật link từ Quiz sang Question để đồng bộ danh sách
      currentQuiz.questions.clear();
      currentQuiz.questions.addAll(newQuestions);
      internalQuizBox.put(currentQuiz);
    }, [quizId, questions]);
  }

  /// 5. Lưu Quiz mới kèm theo Subject
  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    final subject = await _subjectBox.getAsync(subjectId);
    if (subject == null) {
      throw EntityNotFoundException('Môn học không tồn tại.');
    }

    // Thiết lập liên kết (Target thay cho Value)
    quiz.subject.target = subject;

    // ObjectBox tự động lưu relation khi put
    await _quizBox.putAsync(quiz);
  }

  /// 6. Xóa Quiz
  Future<void> deleteQuiz(int id) async {
    final success = await _quizBox.removeAsync(id);
    if (!success) {
      throw EntityNotFoundException('Quiz không tồn tại hoặc đã bị xóa.');
    }
  }
}
