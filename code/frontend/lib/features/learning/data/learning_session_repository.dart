import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/extensions/condition_extension.dart';
import 'package:frontend/core/extensions/query_builder_extension.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/learning_setting.dart';
import 'package:frontend/features/learning/models/search_params/learning_session_search_params.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_session_repository.g.dart';

@riverpod
LearningSessionRepository learningSessionRepository(Ref ref) {
  return LearningSessionRepository();
}

class LearningSessionRepository {
  final _sessionBox = ObjectBoxService.instance.get<LearningSession>();
  final _sessionDetailBox = ObjectBoxService.instance
      .get<LearningSessionDetail>();
  final _quizBox = ObjectBoxService.instance.get<Quiz>();

  // 1. Hàm helper xây dựng QueryBuilder dùng chung
  QueryBuilder<LearningSession> _buildQuery(
    LearningSessionSearchParams params,
  ) {
    Condition<LearningSession>? condition;

    condition = condition
        .safeAnd(params.quizId, LearningSession_.quiz.equals)
        .safeAnd(params.mode, LearningSession_.learningMode.equals)
        .safeAnd(params.isCompleted, LearningSession_.isCompleted.equals);

    final queryBuilder = _sessionBox.query(condition);

    queryBuilder.safeLink(
      params.keyword,
      LearningSession_.quiz,
      (keyword) => Quiz_.name.contains(keyword, caseSensitive: false),
    );

    return queryBuilder;
  }

  // 2. Watch danh sách phiên học
  Stream<List<LearningSession>> watchSessions(
    LearningSessionSearchParams params,
  ) {
    final queryBuilder = _buildQuery(params);
    queryBuilder.order(LearningSession_.startTime, flags: Order.descending);

    return queryBuilder.watch(triggerImmediately: true).map((query) {
      query
        ..limit = params.size
        ..offset = params.page * params.size;
      return query.find();
    });
  }

  // 3. Tính tổng số trang
  Stream<int> watchTotalPages(LearningSessionSearchParams params) {
    final queryBuilder = _buildQuery(params);
    return queryBuilder.watch(triggerImmediately: true).map((query) {
      final totalCount = query.count();
      if (totalCount == 0) return 0;
      return (totalCount / params.size).ceil();
    });
  }

  // 4. Xem chi tiết một phiên học
  Stream<LearningSession?> watchSession(int id) {
    return _sessionBox
        .query(LearningSession_.id.equals(id))
        .watch(triggerImmediately: true)
        .map(((query) => query.findFirst()));
  }

  // --- CÁC HÀM THAY ĐỔI DỮ LIỆU ---

  Future<LearningSession> createSession({
    required int quizId,
    required LearningSetting setting,
  }) async {
    final quiz = await _quizBox.getAsync(quizId);
    if (quiz == null) throw EntityNotFoundException('Quiz không tồn tại.');

    final session = LearningSession(
      learningMode: setting.learningMode.toValue(),
      shuffleQuestions: setting.shuffleQuestions,
      shuffleAnswers: setting.shuffleOptions,
      timeLimit: setting.learningMode == LearningMode.exam
          ? setting.customTimeLimit
          : null,
    );
    session.quiz.target = quiz;

    var targetQuestions = quiz.questions.sublist(
      setting.fromIndex.clamp(0, quiz.questions.length),
      (setting.toIndex + 1).clamp(0, quiz.questions.length),
    );

    if (setting.shuffleQuestions) targetQuestions.shuffle();

    final details = targetQuestions.map((question) {
      final detail = LearningSessionDetail(isChecked: false);
      detail.question.target = question;
      detail.learningSession.target = session;
      return detail;
    }).toList();

    session.learningSessionDetails.addAll(details);
    _sessionBox.put(session);

    return session;
  }

  /// Làm lại toàn bộ: Đổi ID về 0 để clone
  Future<LearningSession> retakeSession(int oldSessionId) async {
    final session = await _sessionBox.getAsync(oldSessionId);
    if (session == null) {
      throw EntityNotFoundException('Session không tìm thấy.');
    }

    // 1. Đưa ID về 0 để tạo bản ghi mới
    session.id = 0;
    session.startTime = DateTime.now();
    session.endTime = null;
    session.currentIndex = 0;
    session.studyTime = 0;
    session.totalCorrect = 0;
    session.totalWrong = 0;
    session.isCompleted = false;
    final sessionId = _sessionBox.put(session);
    session.id = sessionId; // Cập nhật lại ID mới sau khi lưu

    // 2. Clone toàn bộ Details (con)
    for (var detail in session.learningSessionDetails) {
      detail.id = 0; // Quan trọng: Phải reset ID con về 0
      detail.isChecked = false;
      detail.isCorrect = null;
      detail.selectedAnswers.clear();
      detail.learningSession.target = session; // Trỏ về cha mới
    }
    _sessionDetailBox.putMany(session.learningSessionDetails);

    return session;
  }

  /// Luyện tập câu sai: Chỉ giữ lại các câu sai và đổi ID về 0
  Future<LearningSession> createMistakeSession(int oldSessionId) async {
    final session = await _sessionBox.getAsync(oldSessionId);
    if (session == null) {
      throw EntityNotFoundException('Session không tìm thấy.');
    }

    // 1. Lọc danh sách câu sai trước khi reset session
    final mistakeDetails = session.learningSessionDetails
        .where((d) => d.isChecked && d.isCorrect == false)
        .toList();

    if (mistakeDetails.isEmpty) {
      throw EntityNotFoundException('Không có câu nào làm sai để luyện tập!');
    }

    // 2. Reset session cha
    session.id = 0;
    session.currentIndex = 0;
    session.studyTime = 0;
    session.totalCorrect = 0;
    session.totalWrong = 0;
    session.isCompleted = false;
    session.startTime = DateTime.now();
    session.endTime = null;
    final newSessionId = _sessionBox.put(session);
    session.id = newSessionId; // Cập nhật lại ID mới sau khi lưu

    for (var detail in mistakeDetails) {
      detail.id = 0; // Biến thành bản ghi mới
      detail.isChecked = false;
      detail.isCorrect = null;
      detail.selectedAnswers.clear();
      detail.learningSession.target = session;
    }
    _sessionDetailBox.putMany(mistakeDetails);

    return session;
  }

  Future<void> updateSession(LearningSession session) async {
    _sessionBox.put(session);
  }

  Future<void> completeSession(int id) async {
    final session = await _sessionBox.getAsync(id);
    if (session != null) {
      session.isCompleted = true;
      session.endTime = DateTime.now();

      // Tận dụng hàm update stats trực tiếp trên instance
      session.totalCorrect = session.learningSessionDetails
          .where((d) => d.isCorrect == true)
          .length;
      session.totalWrong = session.learningSessionDetails
          .where((d) => d.isChecked && d.isCorrect == false)
          .length;

      _sessionBox.put(session);
    }
  }

  Future<void> deleteSession(int id) async {
    _sessionBox.remove(id);
  }
}
