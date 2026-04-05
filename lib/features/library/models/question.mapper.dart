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
  static ToOne<Quiz> _$quiz(Question v) => v.quiz;
  static const Field<Question, ToOne<Quiz>> _f$quiz = Field(
    'quiz',
    _$quiz,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Question> fields = const {
    #id: _f$id,
    #content: _f$content,
    #explanation: _f$explanation,
    #answers: _f$answers,
    #sessionDetails: _f$sessionDetails,
    #quiz: _f$quiz,
  };

  static Question _instantiate(DecodingData data) {
    return Question(
      id: data.dec(_f$id),
      content: data.dec(_f$content),
      explanation: data.dec(_f$explanation),
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

  QuestionCopyWith<Question, Question, Question> get copyWith =>
      _QuestionCopyWithImpl<Question, Question>(
        this as Question,
        $identity,
        $identity,
      );
}

extension QuestionValueCopy<$R, $Out> on ObjectCopyWith<$R, Question, $Out> {
  QuestionCopyWith<$R, Question, $Out> get $asQuestion =>
      $base.as((v, t, t2) => _QuestionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuestionCopyWith<$R, $In extends Question, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? content, String? explanation});
  QuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Question, $Out>
    implements QuestionCopyWith<$R, Question, $Out> {
  _QuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Question> $mapper =
      QuestionMapper.ensureInitialized();
  @override
  $R call({int? id, String? content, String? explanation}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (content != null) #content: content,
      if (explanation != null) #explanation: explanation,
    }),
  );
  @override
  Question $make(CopyWithData data) => Question(
    id: data.get(#id, or: $value.id),
    content: data.get(#content, or: $value.content),
    explanation: data.get(#explanation, or: $value.explanation),
  );

  @override
  QuestionCopyWith<$R2, Question, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

