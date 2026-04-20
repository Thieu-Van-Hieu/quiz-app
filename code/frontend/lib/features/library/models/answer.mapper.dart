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
  static int _$indexOrder(Answer v) => v.indexOrder;
  static const Field<Answer, int> _f$indexOrder = Field(
    'indexOrder',
    _$indexOrder,
    key: r'index_order',
    opt: true,
    def: 0,
  );
  static int _$questionTargetId(Answer v) => v.questionTargetId;
  static const Field<Answer, int> _f$questionTargetId = Field(
    'questionTargetId',
    _$questionTargetId,
    key: r'question_target_id',
    opt: true,
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
    #indexOrder: _f$indexOrder,
    #questionTargetId: _f$questionTargetId,
    #question: _f$question,
    #sessionDetails: _f$sessionDetails,
  };

  static Answer _instantiate(DecodingData data) {
    return Answer(
      id: data.dec(_f$id),
      content: data.dec(_f$content),
      isCorrect: data.dec(_f$isCorrect),
      indexOrder: data.dec(_f$indexOrder),
      questionTargetId: data.dec(_f$questionTargetId),
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
}

