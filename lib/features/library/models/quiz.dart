import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:objectbox/objectbox.dart';

part 'quiz.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class Quiz with QuizMappable {
  @Id()
  int id;

  String name;

  // 1. Relation ToOne: Để ngoài constructor
  final subject = ToOne<Subject>();

  // 2. Relation ToMany (Backlink): Để ngoài constructor
  @Backlink('quiz')
  final questions = ToMany<Question>();

  Quiz({
    this.id = 0,
    required this.name,
    // 3. VIRTUAL PARAMETERS: Trick thần thánh
    int? subjectTargetId,
    List<Question>? questionsList,
  }) {
    // Gán ID cho ToOne subject
    if (subjectTargetId != null && subjectTargetId > 0) {
      subject.targetId = subjectTargetId;
    }

    // Đổ list questions vào Backlink (ObjectBox sẽ tự hiểu quan hệ khi save)
    if (questionsList != null) {
      questions.clear();
      questions.addAll(questionsList);
    }
  }

  // 4. MappableField: Đồng bộ hóa dữ liệu để copyWith luôn có data mới nhất
  @MappableField(key: 'subjectTargetId')
  int get subjectTargetId => subject.targetId;

  @MappableField(key: 'questionsList')
  List<Question> get questionsList => questions.toList();

  // --- Helper Methods ---
  static Quiz fromMap(Map<String, dynamic> map) => QuizMapper.fromMap(map);

  static Quiz fromJson(String json) => QuizMapper.fromJson(json);
}
