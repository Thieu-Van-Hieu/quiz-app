// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'learning_setting.dart';

class LearningSettingMapper extends ClassMapperBase<LearningSetting> {
  LearningSettingMapper._();

  static LearningSettingMapper? _instance;
  static LearningSettingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LearningSettingMapper._());
      LearningModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LearningSetting';

  static int _$fromIndex(LearningSetting v) => v.fromIndex;
  static const Field<LearningSetting, int> _f$fromIndex = Field(
    'fromIndex',
    _$fromIndex,
    opt: true,
    def: 0,
  );
  static int _$toIndex(LearningSetting v) => v.toIndex;
  static const Field<LearningSetting, int> _f$toIndex = Field(
    'toIndex',
    _$toIndex,
    opt: true,
    def: 10,
  );
  static bool _$shuffleQuestions(LearningSetting v) => v.shuffleQuestions;
  static const Field<LearningSetting, bool> _f$shuffleQuestions = Field(
    'shuffleQuestions',
    _$shuffleQuestions,
    opt: true,
    def: false,
  );
  static bool _$shuffleOptions(LearningSetting v) => v.shuffleOptions;
  static const Field<LearningSetting, bool> _f$shuffleOptions = Field(
    'shuffleOptions',
    _$shuffleOptions,
    opt: true,
    def: false,
  );
  static LearningMode _$learningMode(LearningSetting v) => v.learningMode;
  static const Field<LearningSetting, LearningMode> _f$learningMode = Field(
    'learningMode',
    _$learningMode,
    opt: true,
    def: LearningMode.practice,
  );
  static int? _$customTimeLimit(LearningSetting v) => v.customTimeLimit;
  static const Field<LearningSetting, int> _f$customTimeLimit = Field(
    'customTimeLimit',
    _$customTimeLimit,
    opt: true,
  );

  @override
  final MappableFields<LearningSetting> fields = const {
    #fromIndex: _f$fromIndex,
    #toIndex: _f$toIndex,
    #shuffleQuestions: _f$shuffleQuestions,
    #shuffleOptions: _f$shuffleOptions,
    #learningMode: _f$learningMode,
    #customTimeLimit: _f$customTimeLimit,
  };

  static LearningSetting _instantiate(DecodingData data) {
    return LearningSetting(
      fromIndex: data.dec(_f$fromIndex),
      toIndex: data.dec(_f$toIndex),
      shuffleQuestions: data.dec(_f$shuffleQuestions),
      shuffleOptions: data.dec(_f$shuffleOptions),
      learningMode: data.dec(_f$learningMode),
      customTimeLimit: data.dec(_f$customTimeLimit),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LearningSetting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LearningSetting>(map);
  }

  static LearningSetting fromJson(String json) {
    return ensureInitialized().decodeJson<LearningSetting>(json);
  }
}

mixin LearningSettingMappable {
  String toJson() {
    return LearningSettingMapper.ensureInitialized()
        .encodeJson<LearningSetting>(this as LearningSetting);
  }

  Map<String, dynamic> toMap() {
    return LearningSettingMapper.ensureInitialized().encodeMap<LearningSetting>(
      this as LearningSetting,
    );
  }

  LearningSettingCopyWith<LearningSetting, LearningSetting, LearningSetting>
  get copyWith =>
      _LearningSettingCopyWithImpl<LearningSetting, LearningSetting>(
        this as LearningSetting,
        $identity,
        $identity,
      );
}

extension LearningSettingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LearningSetting, $Out> {
  LearningSettingCopyWith<$R, LearningSetting, $Out> get $asLearningSetting =>
      $base.as((v, t, t2) => _LearningSettingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LearningSettingCopyWith<$R, $In extends LearningSetting, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? fromIndex,
    int? toIndex,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    LearningMode? learningMode,
    int? customTimeLimit,
  });
  LearningSettingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LearningSettingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LearningSetting, $Out>
    implements LearningSettingCopyWith<$R, LearningSetting, $Out> {
  _LearningSettingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LearningSetting> $mapper =
      LearningSettingMapper.ensureInitialized();
  @override
  $R call({
    int? fromIndex,
    int? toIndex,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    LearningMode? learningMode,
    Object? customTimeLimit = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fromIndex != null) #fromIndex: fromIndex,
      if (toIndex != null) #toIndex: toIndex,
      if (shuffleQuestions != null) #shuffleQuestions: shuffleQuestions,
      if (shuffleOptions != null) #shuffleOptions: shuffleOptions,
      if (learningMode != null) #learningMode: learningMode,
      if (customTimeLimit != $none) #customTimeLimit: customTimeLimit,
    }),
  );
  @override
  LearningSetting $make(CopyWithData data) => LearningSetting(
    fromIndex: data.get(#fromIndex, or: $value.fromIndex),
    toIndex: data.get(#toIndex, or: $value.toIndex),
    shuffleQuestions: data.get(#shuffleQuestions, or: $value.shuffleQuestions),
    shuffleOptions: data.get(#shuffleOptions, or: $value.shuffleOptions),
    learningMode: data.get(#learningMode, or: $value.learningMode),
    customTimeLimit: data.get(#customTimeLimit, or: $value.customTimeLimit),
  );

  @override
  LearningSettingCopyWith<$R2, LearningSetting, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LearningSettingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

