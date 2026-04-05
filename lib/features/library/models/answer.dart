import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:objectbox/objectbox.dart';

part 'answer.mapper.dart';

@MappableClass(
  generateMethods:
      GenerateMethods.decode | GenerateMethods.encode | GenerateMethods.copy,
  caseStyle:
      CaseStyle.snakeCase, // Thêm cái này nếu API Spring Boot dùng snake_case
)
@Entity()
class Answer with AnswerMappable {
  @Id()
  int id;

  final String content;
  final bool isCorrect;

  final question = ToOne<Question>();
  @Backlink('selectedAnswers') // Định nghĩa backlink đến SessionDetail
  final sessionDetails = ToMany<LearningSessionDetail>();

  Answer({this.id = 0, required this.content, this.isCorrect = false});

  static Answer fromMap(Map<String, dynamic> map) => AnswerMapper.fromMap(map);
  static Answer fromJson(String json) => AnswerMapper.fromJson(json);
}
