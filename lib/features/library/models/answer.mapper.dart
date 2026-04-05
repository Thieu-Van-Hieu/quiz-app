// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'answer.dart';

class AnswerMapper extends ClassMapperBase<Answer> {
  AnswerMapper._();

  static AnswerMapper? _instance;
  static AnswerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AnswerMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Answer';

  static int _$id(Answer v) => v.id;
  static const Field<Answer, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$content(Answer v) => v.content;
  static const Field<Answer, String> _f$content = Field('content', _$content);
  static bool _$isCorrect(Answer v) => v.isCorrect;
  static const Field<Answer, bool> _f$isCorrect = Field(
    'isCorrect',
    _$isCorrect,
    key: r'is_correct',
    opt: true,
    def: false,
  );
  static ToOne<Question> _$question(Answer v) => v.question;
  static const Field<Answer, ToOne<Question>> _f$question = Field(
    'question',
    _$question,
    mode: FieldMode.member,
  );
  static ToMany<LearningSessionDetail> _$sessionDetails(Answer v) =>
      v.sessionDetails;
  static const Field<Answer, ToMany<LearningSessionDetail>> _f$sessionDetails =
      Field(
        'sessionDetails',
        _$sessionDetails,
        key: r'session_details',
        mode: FieldMode.member,
      );

  @override
  final MappableFields<Answer> fields = const {
    #id: _f$id,
    #content: _f$content,
    #isCorrect: _f$isCorrect,
    #question: _f$question,
    #sessionDetails: _f$sessionDetails,
  };

  static Answer _instantiate(DecodingData data) {
    return Answer(
      id: data.dec(_f$id),
      content: data.dec(_f$content),
      isCorrect: data.dec(_f$isCorrect),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Answer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Answer>(map);
  }

  static Answer fromJson(String json) {
    return ensureInitialized().decodeJson<Answer>(json);
  }
}

mixin AnswerMappable {
  String toJson() {
    return AnswerMapper.ensureInitialized().encodeJson<Answer>(this as Answer);
  }

  Map<String, dynamic> toMap() {
    return AnswerMapper.ensureInitialized().encodeMap<Answer>(this as Answer);
  }

  AnswerCopyWith<Answer, Answer, Answer> get copyWith =>
      _AnswerCopyWithImpl<Answer, Answer>(this as Answer, $identity, $identity);
}

extension AnswerValueCopy<$R, $Out> on ObjectCopyWith<$R, Answer, $Out> {
  AnswerCopyWith<$R, Answer, $Out> get $asAnswer =>
      $base.as((v, t, t2) => _AnswerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AnswerCopyWith<$R, $In extends Answer, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? content, bool? isCorrect});
  AnswerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AnswerCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Answer, $Out>
    implements AnswerCopyWith<$R, Answer, $Out> {
  _AnswerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Answer> $mapper = AnswerMapper.ensureInitialized();
  @override
  $R call({int? id, String? content, bool? isCorrect}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (content != null) #content: content,
      if (isCorrect != null) #isCorrect: isCorrect,
    }),
  );
  @override
  Answer $make(CopyWithData data) => Answer(
    id: data.get(#id, or: $value.id),
    content: data.get(#content, or: $value.content),
    isCorrect: data.get(#isCorrect, or: $value.isCorrect),
  );

  @override
  AnswerCopyWith<$R2, Answer, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AnswerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

