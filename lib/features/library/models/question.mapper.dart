// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'question.dart';

class QuestionMapper extends ClassMapperBase<Question> {
  QuestionMapper._();

  static QuestionMapper? _instance;
  static QuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuestionMapper._());
      AnswerMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Question';

  static int _$id(Question v) => v.id;
  static const Field<Question, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 0,
  );
  static String _$content(Question v) => v.content;
  static const Field<Question, String> _f$content = Field('content', _$content);
  static String _$explanation(Question v) => v.explanation;
  static const Field<Question, String> _f$explanation = Field(
    'explanation',
    _$explanation,
    opt: true,
    def: '',
  );
  static int _$quizTargetId(Question v) => v.quizTargetId;
  static const Field<Question, int> _f$quizTargetId = Field(
    'quizTargetId',
    _$quizTargetId,
    opt: true,
  );
  static List<Answer> _$answersList(Question v) => v.answersList;
  static const Field<Question, List<Answer>> _f$answersList = Field(
    'answersList',
    _$answersList,
    opt: true,
  );
  static ToOne<Quiz> _$quiz(Question v) => v.quiz;
  static const Field<Question, ToOne<Quiz>> _f$quiz = Field(
    'quiz',
    _$quiz,
    mode: FieldMode.member,
  );
  static ToMany<Answer> _$answers(Question v) => v.answers;
  static const Field<Question, ToMany<Answer>> _f$answers = Field(
    'answers',
    _$answers,
    mode: FieldMode.member,
  );
  static ToMany<LearningSessionDetail> _$sessionDetails(Question v) =>
      v.sessionDetails;
  static const Field<Question, ToMany<LearningSessionDetail>>
  _f$sessionDetails = Field(
    'sessionDetails',
    _$sessionDetails,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Question> fields = const {
    #id: _f$id,
    #content: _f$content,
    #explanation: _f$explanation,
    #quizTargetId: _f$quizTargetId,
    #answersList: _f$answersList,
    #quiz: _f$quiz,
    #answers: _f$answers,
    #sessionDetails: _f$sessionDetails,
  };

  static Question _instantiate(DecodingData data) {
    return Question(
      id: data.dec(_f$id),
      content: data.dec(_f$content),
      explanation: data.dec(_f$explanation),
      quizTargetId: data.dec(_f$quizTargetId),
      answersList: data.dec(_f$answersList),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Question fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Question>(map);
  }

  static Question fromJson(String json) {
    return ensureInitialized().decodeJson<Question>(json);
  }
}

mixin QuestionMappable {
  String toJson() {
    return QuestionMapper.ensureInitialized().encodeJson<Question>(
      this as Question,
    );
  }

  Map<String, dynamic> toMap() {
    return QuestionMapper.ensureInitialized().encodeMap<Question>(
      this as Question,
    );
  }
}

