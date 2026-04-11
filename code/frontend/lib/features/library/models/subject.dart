import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:objectbox/objectbox.dart';

part 'subject.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class Subject with SubjectMappable {
  @Id()
  int id;
  @Index(
    type: IndexType.value,
  ) // Tạo index trên trường code để tìm kiếm nhanh hơn
  String code;
  @Index(
    type: IndexType.value,
  ) // Tạo index trên trường name để tìm kiếm nhanh hơn
  String name;
  @Backlink('subject') // Định nghĩa backlink đến Quiz
  final quizzes = ToMany<Quiz>();

  Subject({this.id = 0, required this.code, this.name = ''});

  static Subject fromMap(Map<String, dynamic> map) =>
      SubjectMapper.fromMap(map);

  static Subject fromJson(String json) => SubjectMapper.fromJson(json);
}
