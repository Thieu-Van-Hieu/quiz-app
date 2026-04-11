// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'learning_session_detail.dart';

class LearningSessionDetailMapper
    extends ClassMapperBase<LearningSessionDetail> {
  LearningSessionDetailMapper._();

  static LearningSessionDetailMapper? _instance;
  static LearningSessionDetailMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LearningSessionDetailMapper._());
      AnswerMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LearningSessionDetail';

  static int _$id(LearningSessionDetail v) => v.id;
  static const Field<LearningSessionDetail, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 0,
  );
  static bool _$isChecked(LearningSessionDetail v) => v.isChecked;
  static const Field<LearningSessionDetail, bool> _f$isChecked = Field(
    'isChecked',
    _$isChecked,
    opt: true,
    def: false,
  );
  static bool _$isSeen(LearningSessionDetail v) => v.isSeen;
  static const Field<LearningSessionDetail, bool> _f$isSeen = Field(
    'isSeen',
    _$isSeen,
    opt: true,
    def: false,
  );
  static bool? _$isCorrect(LearningSessionDetail v) => v.isCorrect;
  static const Field<LearningSessionDetail, bool> _f$isCorrect = Field(
    'isCorrect',
    _$isCorrect,
    opt: true,
  );
  static const Field<LearningSessionDetail, int> _f$learningSessionTargetId =
      Field('learningSessionTargetId', null, mode: FieldMode.param, opt: true);
  static int _$questionTargetId(LearningSessionDetail v) => v.questionTargetId;
  static const Field<LearningSessionDetail, int> _f$questionTargetId = Field(
    'questionTargetId',
    _$questionTargetId,
    opt: true,
  );
  static List<Answer> _$selectedAnswersList(LearningSessionDetail v) =>
      v.selectedAnswersList;
  static const Field<LearningSessionDetail, List<Answer>>
  _f$selectedAnswersList = Field(
    'selectedAnswersList',
    _$selectedAnswersList,
    opt: true,
  );
  static int _$learningSessionId(LearningSessionDetail v) =>
      v.learningSessionId;
  static const Field<LearningSessionDetail, int> _f$learningSessionId = Field(
    'learningSessionId',
    _$learningSessionId,
  );
  static ToOne<LearningSession> _$learningSession(LearningSessionDetail v) =>
      v.learningSession;
  static const Field<LearningSessionDetail, ToOne<LearningSession>>
  _f$learningSession = Field(
    'learningSession',
    _$learningSession,
    mode: FieldMode.member,
  );
  static ToOne<Question> _$question(LearningSessionDetail v) => v.question;
  static const Field<LearningSessionDetail, ToOne<Question>> _f$question =
      Field('question', _$question, mode: FieldMode.member);
  static ToMany<Answer> _$selectedAnswers(LearningSessionDetail v) =>
      v.selectedAnswers;
  static const Field<LearningSessionDetail, ToMany<Answer>> _f$selectedAnswers =
      Field('selectedAnswers', _$selectedAnswers, mode: FieldMode.member);

  @override
  final MappableFields<LearningSessionDetail> fields = const {
    #id: _f$id,
    #isChecked: _f$isChecked,
    #isSeen: _f$isSeen,
    #isCorrect: _f$isCorrect,
    #learningSessionTargetId: _f$learningSessionTargetId,
    #questionTargetId: _f$questionTargetId,
    #selectedAnswersList: _f$selectedAnswersList,
    #learningSessionId: _f$learningSessionId,
    #learningSession: _f$learningSession,
    #question: _f$question,
    #selectedAnswers: _f$selectedAnswers,
  };

  static LearningSessionDetail _instantiate(DecodingData data) {
    return LearningSessionDetail(
      id: data.dec(_f$id),
      isChecked: data.dec(_f$isChecked),
      isSeen: data.dec(_f$isSeen),
      isCorrect: data.dec(_f$isCorrect),
      learningSessionTargetId: data.dec(_f$learningSessionTargetId),
      questionTargetId: data.dec(_f$questionTargetId),
      selectedAnswersList: data.dec(_f$selectedAnswersList),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LearningSessionDetail fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LearningSessionDetail>(map);
  }

  static LearningSessionDetail fromJson(String json) {
    return ensureInitialized().decodeJson<LearningSessionDetail>(json);
  }
}

mixin LearningSessionDetailMappable {
  String toJson() {
    return LearningSessionDetailMapper.ensureInitialized()
        .encodeJson<LearningSessionDetail>(this as LearningSessionDetail);
  }

  Map<String, dynamic> toMap() {
    return LearningSessionDetailMapper.ensureInitialized()
        .encodeMap<LearningSessionDetail>(this as LearningSessionDetail);
  }
}

