// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'quiz.dart';

class QuizMapper extends ClassMapperBase<Quiz> {
  QuizMapper._();

  static QuizMapper? _instance;
  static QuizMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizMapper._());
      QuestionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Quiz';

  static int _$id(Quiz v) => v.id;
  static const Field<Quiz, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$name(Quiz v) => v.name;
  static const Field<Quiz, String> _f$name = Field('name', _$name);
  static int _$subjectTargetId(Quiz v) => v.subjectTargetId;
  static const Field<Quiz, int> _f$subjectTargetId = Field(
    'subjectTargetId',
    _$subjectTargetId,
    opt: true,
  );
  static List<Question> _$questionsList(Quiz v) => v.questionsList;
  static const Field<Quiz, List<Question>> _f$questionsList = Field(
    'questionsList',
    _$questionsList,
    opt: true,
  );
  static ToOne<Subject> _$subject(Quiz v) => v.subject;
  static const Field<Quiz, ToOne<Subject>> _f$subject = Field(
    'subject',
    _$subject,
    mode: FieldMode.member,
  );
  static ToMany<Question> _$questions(Quiz v) => v.questions;
  static const Field<Quiz, ToMany<Question>> _f$questions = Field(
    'questions',
    _$questions,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Quiz> fields = const {
    #id: _f$id,
    #name: _f$name,
    #subjectTargetId: _f$subjectTargetId,
    #questionsList: _f$questionsList,
    #subject: _f$subject,
    #questions: _f$questions,
  };

  static Quiz _instantiate(DecodingData data) {
    return Quiz(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      subjectTargetId: data.dec(_f$subjectTargetId),
      questionsList: data.dec(_f$questionsList),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Quiz fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Quiz>(map);
  }

  static Quiz fromJson(String json) {
    return ensureInitialized().decodeJson<Quiz>(json);
  }
}

mixin QuizMappable {
  String toJson() {
    return QuizMapper.ensureInitialized().encodeJson<Quiz>(this as Quiz);
  }

  Map<String, dynamic> toMap() {
    return QuizMapper.ensureInitialized().encodeMap<Quiz>(this as Quiz);
  }
}

