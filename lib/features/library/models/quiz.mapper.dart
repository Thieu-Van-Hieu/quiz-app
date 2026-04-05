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
    }
    return _instance!;
  }

  @override
  final String id = 'Quiz';

  static int _$id(Quiz v) => v.id;
  static const Field<Quiz, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$name(Quiz v) => v.name;
  static const Field<Quiz, String> _f$name = Field('name', _$name);
  static ToMany<Question> _$questions(Quiz v) => v.questions;
  static const Field<Quiz, ToMany<Question>> _f$questions = Field(
    'questions',
    _$questions,
    mode: FieldMode.member,
  );
  static ToOne<Subject> _$subject(Quiz v) => v.subject;
  static const Field<Quiz, ToOne<Subject>> _f$subject = Field(
    'subject',
    _$subject,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Quiz> fields = const {
    #id: _f$id,
    #name: _f$name,
    #questions: _f$questions,
    #subject: _f$subject,
  };

  static Quiz _instantiate(DecodingData data) {
    return Quiz(id: data.dec(_f$id), name: data.dec(_f$name));
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

  QuizCopyWith<Quiz, Quiz, Quiz> get copyWith =>
      _QuizCopyWithImpl<Quiz, Quiz>(this as Quiz, $identity, $identity);
}

extension QuizValueCopy<$R, $Out> on ObjectCopyWith<$R, Quiz, $Out> {
  QuizCopyWith<$R, Quiz, $Out> get $asQuiz =>
      $base.as((v, t, t2) => _QuizCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizCopyWith<$R, $In extends Quiz, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? name});
  QuizCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _QuizCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Quiz, $Out>
    implements QuizCopyWith<$R, Quiz, $Out> {
  _QuizCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Quiz> $mapper = QuizMapper.ensureInitialized();
  @override
  $R call({int? id, String? name}) => $apply(
    FieldCopyWithData({if (id != null) #id: id, if (name != null) #name: name}),
  );
  @override
  Quiz $make(CopyWithData data) => Quiz(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
  );

  @override
  QuizCopyWith<$R2, Quiz, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _QuizCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

