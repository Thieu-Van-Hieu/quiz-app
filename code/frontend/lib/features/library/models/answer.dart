import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:objectbox/objectbox.dart';

part 'answer.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.snakeCase,
)
@Entity()
class Answer with AnswerMappable {
  @Id()
  int id;

  String content;
  bool isCorrect;
  int indexOrder;

  // 1. ToOne: Để ngoài constructor để ObjectBox không bị lú
  final question = ToOne<Question>();

  // 2. Backlink: Không cần cho vào constructor, không cần trick copyWith
  @Backlink('selectedAnswers')
  final sessionDetails = ToMany<LearningSessionDetail>();

  Answer({
    this.id = 0,
    required this.content,
    this.isCorrect = false,
    this.indexOrder = 0,
    // 3. VIRTUAL PARAMETER: Để copyWith có thể thay đổi question quan hệ
    int? questionTargetId,
  }) {
    if (questionTargetId != null && questionTargetId > 0) {
      question.targetId = questionTargetId;
    }
  }

  // 4. MappableField: Ánh xạ ngược lại để copyWith lấy được ID hiện tại
  @MappableField(key: 'questionTargetId')
  int get questionTargetId => question.targetId;

  // --- Helper Methods ---
  static Answer fromMap(Map<String, dynamic> map) => AnswerMapper.fromMap(map);

  static Answer fromJson(String json) => AnswerMapper.fromJson(json);
}
