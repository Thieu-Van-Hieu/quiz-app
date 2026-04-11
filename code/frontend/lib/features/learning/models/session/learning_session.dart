import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:objectbox/objectbox.dart';

part 'learning_session.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class LearningSession with LearningSessionMappable {
  @Id()
  int id;

  // Relation: ObjectBox yêu cầu 'final' để quản lý Proxy,
  // nhưng chúng ta sẽ ignore để Mappable không can thiệp vào.
  final quiz = ToOne<Quiz>();

  // --- Core Info ---
  String learningMode;

  @Transient()
  LearningMode get learningModeEnum => LearningMode.fromValue(learningMode);

  @Property(type: PropertyType.date)
  DateTime startTime; // Cái này nên giữ final vì khởi tạo 1 lần

  @Property(type: PropertyType.date)
  DateTime? recentLearningDateTime; // Cái này sẽ update mỗi lần học, nên không final

  // --- Config & Progress: Bỏ final để sửa trực tiếp ---
  bool shuffleQuestions;
  bool shuffleAnswers;
  int currentIndex;
  int studyTime;

  // --- Exam Specific ---
  int? timeLimit;
  bool isCompleted;

  @Property(type: PropertyType.date)
  DateTime? endTime;

  // --- Statistics ---
  int totalCorrect;
  int totalWrong;

  @Backlink('learningSession')
  final learningSessionDetails = ToMany<LearningSessionDetail>();

  LearningSession({
    this.id = 0,
    required this.learningMode,
    DateTime? startTime,
    DateTime? recentLearningDateTime,
    this.shuffleQuestions = false,
    this.shuffleAnswers = false,
    this.currentIndex = 0,
    this.studyTime = 0,
    this.timeLimit,
    this.isCompleted = false,
    this.endTime,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    // Virtual parameters để phục vụ copyWith
    int? quizTargetId,
    List<LearningSessionDetail>? detailsList,
  }) : startTime = startTime ?? DateTime.now() {
    // Phục hồi relation khi copyWith tạo object mới
    if (quizTargetId != null && quizTargetId > 0) {
      quiz.targetId = quizTargetId;
    }

    if (detailsList != null) {
      learningSessionDetails.addAll(detailsList);
      // Gán ngược lại cha cho con để tránh "con mất cha" khi dùng copyWith
      for (var detail in learningSessionDetails) {
        detail.learningSession.target = this;
      }
    }
  }

  // Map các trường ảo để copyWith/toJson hoạt động
  @MappableField(key: 'quizTargetId')
  int get quizTargetId => quiz.targetId;

  @MappableField(key: 'detailsList')
  List<LearningSessionDetail> get detailsList =>
      learningSessionDetails.toList();

  // --- Helper Methods ---
  static LearningSession fromMap(Map<String, dynamic> map) =>
      LearningSessionMapper.fromMap(map);

  static LearningSession fromJson(String json) =>
      LearningSessionMapper.fromJson(json);

  LearningSessionDetail? getCurrentLearningSessionDetail() {
    if (learningSessionDetails.isEmpty) return null;
    if (currentIndex < 0 || currentIndex >= learningSessionDetails.length) {
      return learningSessionDetails.first;
    }
    return learningSessionDetails[currentIndex];
  }

  // Thêm hàm này để update stats nhanh không cần copyWith
  void updateStatistics() {
    totalCorrect = learningSessionDetails
        .where((d) => d.isCorrect == true)
        .length;
    totalWrong = learningSessionDetails
        .where((d) => d.isChecked && d.isCorrect == false)
        .length;
  }

  int get accuracyRate {
    final totalAnswered = totalCorrect + totalWrong;
    if (totalAnswered == 0) return 0;
    return ((totalCorrect / totalAnswered) * 100).round();
  }

  int get totalSeen => learningSessionDetails.where((d) => d.isSeen).length;
}
