import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/models/session/learning_session_detail.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:objectbox/objectbox.dart';

part 'question.mapper.dart';

@MappableClass(
  generateMethods: GenerateMethods.decode | GenerateMethods.encode,
  caseStyle: CaseStyle.camelCase,
)
@Entity()
class Question with QuestionMappable {
  @Id()
  int id;

  String content;
  String explanation;

  // 1. ToOne: Cần trick để copyWith hoạt động
  final quiz = ToOne<Quiz>();

  // 2. Backlinks: Giữ nguyên final và không đưa vào constructor
  @Backlink('question')
  final answers = ToMany<Answer>();

  @Backlink('question')
  final sessionDetails = ToMany<LearningSessionDetail>();

  Question({
    this.id = 0,
    required this.content,
    this.explanation = '',
    // 3. VIRTUAL PARAMETER: Trick cho ToOne quiz
    int? quizTargetId,
    // (Tùy chọn) Nếu muốn gán nhanh danh sách answers khi copy
    List<Answer>? answersList,
  }) {
    if (quizTargetId != null && quizTargetId > 0) {
      quiz.targetId = quizTargetId;
    }

    if (answersList != null) {
      answers.clear();
      answers.addAll(answersList);
    }
  }

  void syncAnswers() {
    for (var answer in answers) {
      answer.question.target = this;
    }
  }

  // 4. MappableField: Để lấy ID hiện tại ra khi copyWith
  @MappableField(key: 'quizTargetId')
  int get quizTargetId => quiz.targetId;

  // Getter cho answersList để Mappable có thể đọc dữ liệu hiện tại
  @MappableField(key: 'answersList')
  List<Answer> get answersList => answers.toList();

  // --- Helper Methods ---
  static Question fromMap(Map<String, dynamic> map) =>
      QuestionMapper.fromMap(map);

  static Question fromJson(String json) => QuestionMapper.fromJson(json);
}
