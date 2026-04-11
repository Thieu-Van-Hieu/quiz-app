import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/models/session/learning_session.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:objectbox/objectbox.dart';

part 'learning_session_detail.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class LearningSessionDetail with LearningSessionDetailMappable {
  @Id()
  int id;

  // 1. Relations: Giữ final cho Proxy của ObjectBox nhưng dùng Ignore cho Mapper
  final learningSession = ToOne<LearningSession>();

  final question = ToOne<Question>();

  final selectedAnswers = ToMany<Answer>();

  // Bỏ final để có thể update trực tiếp trong StudyPage
  bool isChecked;
  bool? isCorrect;

  LearningSessionDetail({
    this.id = 0,
    this.isChecked = false,
    this.isCorrect,

    // 2. VIRTUAL PARAMETERS: Giúp Mapper nhận diện ID từ JSON và copyWith
    int? learningSessionTargetId,
    int? questionTargetId,
    List<Answer>? selectedAnswersList,
  }) {
    // Phục hồi liên kết khi khởi tạo (đặc biệt quan trọng khi dùng copyWith)
    if (learningSessionTargetId != null && learningSessionTargetId > 0) {
      learningSession.targetId = learningSessionTargetId;
    }

    if (questionTargetId != null && questionTargetId > 0) {
      question.targetId = questionTargetId;
    }

    if (selectedAnswersList != null) {
      selectedAnswers.clear();
      selectedAnswers.addAll(selectedAnswersList);
    }
  }

  // 3. MappableField: Giữ lại để copyWith/toJson vẫn lấy được data từ Relation
  @MappableField(key: 'learningSessionId')
  int get learningSessionId => learningSession.targetId;

  @MappableField(key: 'questionTargetId')
  int get questionTargetId => question.targetId;

  @MappableField(key: 'selectedAnswersList')
  List<Answer> get selectedAnswersList => selectedAnswers.toList();

  // --- Helper Methods ---
  static LearningSessionDetail fromMap(Map<String, dynamic> map) =>
      LearningSessionDetailMapper.fromMap(map);

  static LearningSessionDetail fromJson(String json) =>
      LearningSessionDetailMapper.fromJson(json);

  /// Cập nhật logic để có thể gọi trực tiếp thay vì phụ thuộc hoàn toàn vào notifier
  bool validateAnswers() {
    final targetQuestion = question.target;
    if (targetQuestion == null) return false;

    final correctIDs = targetQuestion.answers
        .where((a) => a.isCorrect)
        .map((a) => a.id)
        .toSet();

    final selectedIDs = selectedAnswers.map((a) => a.id).toSet();

    if (correctIDs.length != selectedIDs.length) return false;
    return correctIDs.every((id) => selectedIDs.contains(id));
  }
}
