// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'learning_session.dart';

class LearningSessionMapper extends ClassMapperBase<LearningSession> {
  LearningSessionMapper._();

  static LearningSessionMapper? _instance;
  static LearningSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LearningSessionMapper._());
      LearningSessionDetailMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LearningSession';

  static int _$id(LearningSession v) => v.id;
  static const Field<LearningSession, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 0,
  );
  static String _$learningMode(LearningSession v) => v.learningMode;
  static const Field<LearningSession, String> _f$learningMode = Field(
    'learningMode',
    _$learningMode,
  );
  static DateTime _$startTime(LearningSession v) => v.startTime;
  static const Field<LearningSession, DateTime> _f$startTime = Field(
    'startTime',
    _$startTime,
    opt: true,
  );
  static bool _$shuffleQuestions(LearningSession v) => v.shuffleQuestions;
  static const Field<LearningSession, bool> _f$shuffleQuestions = Field(
    'shuffleQuestions',
    _$shuffleQuestions,
    opt: true,
    def: false,
  );
  static bool _$shuffleAnswers(LearningSession v) => v.shuffleAnswers;
  static const Field<LearningSession, bool> _f$shuffleAnswers = Field(
    'shuffleAnswers',
    _$shuffleAnswers,
    opt: true,
    def: false,
  );
  static int _$currentIndex(LearningSession v) => v.currentIndex;
  static const Field<LearningSession, int> _f$currentIndex = Field(
    'currentIndex',
    _$currentIndex,
    opt: true,
    def: 0,
  );
  static int _$studyTime(LearningSession v) => v.studyTime;
  static const Field<LearningSession, int> _f$studyTime = Field(
    'studyTime',
    _$studyTime,
    opt: true,
    def: 0,
  );
  static int? _$timeLimit(LearningSession v) => v.timeLimit;
  static const Field<LearningSession, int> _f$timeLimit = Field(
    'timeLimit',
    _$timeLimit,
    opt: true,
  );
  static bool _$isCompleted(LearningSession v) => v.isCompleted;
  static const Field<LearningSession, bool> _f$isCompleted = Field(
    'isCompleted',
    _$isCompleted,
    opt: true,
    def: false,
  );
  static DateTime? _$endTime(LearningSession v) => v.endTime;
  static const Field<LearningSession, DateTime> _f$endTime = Field(
    'endTime',
    _$endTime,
    opt: true,
  );
  static int _$totalCorrect(LearningSession v) => v.totalCorrect;
  static const Field<LearningSession, int> _f$totalCorrect = Field(
    'totalCorrect',
    _$totalCorrect,
    opt: true,
    def: 0,
  );
  static int _$totalWrong(LearningSession v) => v.totalWrong;
  static const Field<LearningSession, int> _f$totalWrong = Field(
    'totalWrong',
    _$totalWrong,
    opt: true,
    def: 0,
  );
  static int _$quizTargetId(LearningSession v) => v.quizTargetId;
  static const Field<LearningSession, int> _f$quizTargetId = Field(
    'quizTargetId',
    _$quizTargetId,
    opt: true,
  );
  static List<LearningSessionDetail> _$detailsList(LearningSession v) =>
      v.detailsList;
  static const Field<LearningSession, List<LearningSessionDetail>>
  _f$detailsList = Field('detailsList', _$detailsList, opt: true);
  static ToOne<Quiz> _$quiz(LearningSession v) => v.quiz;
  static const Field<LearningSession, ToOne<Quiz>> _f$quiz = Field(
    'quiz',
    _$quiz,
    mode: FieldMode.member,
  );
  static ToMany<LearningSessionDetail> _$learningSessionDetails(
    LearningSession v,
  ) => v.learningSessionDetails;
  static const Field<LearningSession, ToMany<LearningSessionDetail>>
  _f$learningSessionDetails = Field(
    'learningSessionDetails',
    _$learningSessionDetails,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<LearningSession> fields = const {
    #id: _f$id,
    #learningMode: _f$learningMode,
    #startTime: _f$startTime,
    #shuffleQuestions: _f$shuffleQuestions,
    #shuffleAnswers: _f$shuffleAnswers,
    #currentIndex: _f$currentIndex,
    #studyTime: _f$studyTime,
    #timeLimit: _f$timeLimit,
    #isCompleted: _f$isCompleted,
    #endTime: _f$endTime,
    #totalCorrect: _f$totalCorrect,
    #totalWrong: _f$totalWrong,
    #quizTargetId: _f$quizTargetId,
    #detailsList: _f$detailsList,
    #quiz: _f$quiz,
    #learningSessionDetails: _f$learningSessionDetails,
  };

  static LearningSession _instantiate(DecodingData data) {
    return LearningSession(
      id: data.dec(_f$id),
      learningMode: data.dec(_f$learningMode),
      startTime: data.dec(_f$startTime),
      shuffleQuestions: data.dec(_f$shuffleQuestions),
      shuffleAnswers: data.dec(_f$shuffleAnswers),
      currentIndex: data.dec(_f$currentIndex),
      studyTime: data.dec(_f$studyTime),
      timeLimit: data.dec(_f$timeLimit),
      isCompleted: data.dec(_f$isCompleted),
      endTime: data.dec(_f$endTime),
      totalCorrect: data.dec(_f$totalCorrect),
      totalWrong: data.dec(_f$totalWrong),
      quizTargetId: data.dec(_f$quizTargetId),
      detailsList: data.dec(_f$detailsList),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LearningSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LearningSession>(map);
  }

  static LearningSession fromJson(String json) {
    return ensureInitialized().decodeJson<LearningSession>(json);
  }
}

mixin LearningSessionMappable {
  String toJson() {
    return LearningSessionMapper.ensureInitialized()
        .encodeJson<LearningSession>(this as LearningSession);
  }

  Map<String, dynamic> toMap() {
    return LearningSessionMapper.ensureInitialized().encodeMap<LearningSession>(
      this as LearningSession,
    );
  }
}

