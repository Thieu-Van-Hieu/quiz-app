import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:objectbox/objectbox.dart';
part 'quiz.mapper.dart';

@MappableClass(
  generateMethods:
      GenerateMethods.decode | GenerateMethods.encode | GenerateMethods.copy,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class Quiz with QuizMappable {
  @Id()
  int id;
  final String name;
  @Backlink('quiz') // Định nghĩa backlink đến Question
  final questions = ToMany<Question>(); // Liên kết đến Question
  final subject = ToOne<Subject>();

  Quiz({this.id = 0, required this.name});
  static Quiz fromMap(Map<String, dynamic> map) => QuizMapper.fromMap(map);
  static Quiz fromJson(String json) => QuizMapper.fromJson(json);
}
