import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:objectbox/objectbox.dart';
part 'question.mapper.dart';

@MappableClass(
  generateMethods:
      GenerateMethods.decode | GenerateMethods.encode | GenerateMethods.copy,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class Question with QuestionMappable {
  @Id()
  int id;
  final String content;
  @Backlink('question') // Định nghĩa backlink đến Answer
  final answers = ToMany<Answer>();
  @Backlink('question') // Định nghĩa backlink đến SessionDetail
  final sessionDetails = ToMany<LearningSessionDetail>();
  final String explanation; // Giải thích đáp án
  final quiz = ToOne<Quiz>();

  Question({this.id = 0, required this.content, this.explanation = ''});
  static Question fromMap(Map<String, dynamic> map) =>
      QuestionMapper.fromMap(map);
  static Question fromJson(String json) => QuestionMapper.fromJson(json);
}
