import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/extensions/list_extension.dart';
import 'package:frontend/core/extensions/query_builder_extension.dart';
import 'package:frontend/core/search/text_matcher.dart';
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

  // Các bảng ảnh hưởng tới dữ liệu Quiz hiển thị (tên môn, số câu hỏi...)
  Stream<void> _watchQuizChanges() {
    return _db.watchTables([
      _db.store.watch<Quiz>(),
      _db.store.watch<Question>(),
      _db.store.watch<Subject>(),
    ]);
  }

  /// 1. Theo dõi tất cả Quiz của một Subject
  Stream<List<Quiz>> watchAllQuizzes(int subjectId) {
    return _watchQuizChanges().map(
      (_) => _quizBox
          .query(Quiz_.subject.equals(subjectId))
          .buildAndClose((query) => query.find()),
    );
  }

  /// Lấy Quiz của môn học rồi lọc theo keyword bằng TextMatcher
  List<Quiz> _search(QuizSearchParams params) {
    final quizzes = _quizBox
        .query(Quiz_.subject.equals(params.subjectId))
        .buildAndClose((query) => query.find());
    final matcher = TextMatcher(params.keyword ?? '', params.options);
    return matcher.filter(quizzes, (q) => [q.name]);
  }

  /// Theo dõi danh sách Quiz có phân trang và tìm kiếm
  Stream<List<Quiz>> watchQuizzes(QuizSearchParams params) {
    return _watchQuizChanges().map(
      (_) => _search(params).paged(params.page, params.size),
    );
  }

  /// Theo dõi chi tiết 1 Quiz theo ID (cập nhật khi câu hỏi bên trong thay đổi)
  Stream<Quiz?> watchQuiz(int id) {
    return _watchQuizChanges().map((_) => _quizBox.get(id));
  }

  /// Theo dõi tổng số trang
  Stream<int> watchTotalPages(QuizSearchParams params) {
    return _watchQuizChanges().map((_) {
      final totalCount = _search(params).length;
      if (totalCount == 0) return 1;
      return (totalCount / params.size).ceil();
    });
  }

  /// 2. Lấy Quiz theo ID (Không đổi)
  Future<Quiz?> getQuizById(int id) {
    return _quizBox.getAsync(id);
  }

  /// 3. Lấy Quiz theo SubjectId và Tên (Không đổi)
  Future<Quiz?> getQuizBySubjectIdAndName(int subjectId, String name) async {
    final query = _quizBox
        .query(Quiz_.subject.equals(subjectId).and(Quiz_.name.equals(name)))
        .build();

    final result = await query.findFirstAsync();
    query.close();
    return result;
  }

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
        q.syncAnswers();
      }

      internalQuestionBox.putMany(newQuestions);

      currentQuiz.questions.clear();
      currentQuiz.questions.addAll(newQuestions);

      // Lệnh put này kích hoạt sự thay đổi của bảng Quiz
      internalQuizBox.put(currentQuiz);
    }, [quizId, questions]);
  }

  /// 5. Lưu Quiz mới kèm theo Subject
  Future<void> saveQuiz(int subjectId, Quiz quiz) async {
    final subject = await _subjectBox.getAsync(subjectId);
    if (subject == null) {
      throw EntityNotFoundException('Môn học không tồn tại.');
    }

    quiz.subject.target = subject;
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
