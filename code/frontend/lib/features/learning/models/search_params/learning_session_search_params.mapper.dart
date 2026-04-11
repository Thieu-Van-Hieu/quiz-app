// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'learning_session_search_params.dart';

class LearningSessionSearchParamsMapper
    extends ClassMapperBase<LearningSessionSearchParams> {
  LearningSessionSearchParamsMapper._();

  static LearningSessionSearchParamsMapper? _instance;
  static LearningSessionSearchParamsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = LearningSessionSearchParamsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'LearningSessionSearchParams';

  static int? _$quizId(LearningSessionSearchParams v) => v.quizId;
  static const Field<LearningSessionSearchParams, int> _f$quizId = Field(
    'quizId',
    _$quizId,
    opt: true,
  );
  static String? _$mode(LearningSessionSearchParams v) => v.mode;
  static const Field<LearningSessionSearchParams, String> _f$mode = Field(
    'mode',
    _$mode,
    opt: true,
  );
  static String? _$keyword(LearningSessionSearchParams v) => v.keyword;
  static const Field<LearningSessionSearchParams, String> _f$keyword = Field(
    'keyword',
    _$keyword,
    opt: true,
  );
  static bool? _$isCompleted(LearningSessionSearchParams v) => v.isCompleted;
  static const Field<LearningSessionSearchParams, bool> _f$isCompleted = Field(
    'isCompleted',
    _$isCompleted,
    opt: true,
  );
  static int _$size(LearningSessionSearchParams v) => v.size;
  static const Field<LearningSessionSearchParams, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
    def: 10,
  );
  static int _$page(LearningSessionSearchParams v) => v.page;
  static const Field<LearningSessionSearchParams, int> _f$page = Field(
    'page',
    _$page,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<LearningSessionSearchParams> fields = const {
    #quizId: _f$quizId,
    #mode: _f$mode,
    #keyword: _f$keyword,
    #isCompleted: _f$isCompleted,
    #size: _f$size,
    #page: _f$page,
  };

  static LearningSessionSearchParams _instantiate(DecodingData data) {
    return LearningSessionSearchParams(
      quizId: data.dec(_f$quizId),
      mode: data.dec(_f$mode),
      keyword: data.dec(_f$keyword),
      isCompleted: data.dec(_f$isCompleted),
      size: data.dec(_f$size),
      page: data.dec(_f$page),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LearningSessionSearchParams fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LearningSessionSearchParams>(map);
  }

  static LearningSessionSearchParams fromJson(String json) {
    return ensureInitialized().decodeJson<LearningSessionSearchParams>(json);
  }
}

mixin LearningSessionSearchParamsMappable {
  String toJson() {
    return LearningSessionSearchParamsMapper.ensureInitialized()
        .encodeJson<LearningSessionSearchParams>(
          this as LearningSessionSearchParams,
        );
  }

  Map<String, dynamic> toMap() {
    return LearningSessionSearchParamsMapper.ensureInitialized()
        .encodeMap<LearningSessionSearchParams>(
          this as LearningSessionSearchParams,
        );
  }

  LearningSessionSearchParamsCopyWith<
    LearningSessionSearchParams,
    LearningSessionSearchParams,
    LearningSessionSearchParams
  >
  get copyWith =>
      _LearningSessionSearchParamsCopyWithImpl<
        LearningSessionSearchParams,
        LearningSessionSearchParams
      >(this as LearningSessionSearchParams, $identity, $identity);
}

extension LearningSessionSearchParamsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LearningSessionSearchParams, $Out> {
  LearningSessionSearchParamsCopyWith<$R, LearningSessionSearchParams, $Out>
  get $asLearningSessionSearchParams => $base.as(
    (v, t, t2) => _LearningSessionSearchParamsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LearningSessionSearchParamsCopyWith<
  $R,
  $In extends LearningSessionSearchParams,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? quizId,
    String? mode,
    String? keyword,
    bool? isCompleted,
    int? size,
    int? page,
  });
  LearningSessionSearchParamsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LearningSessionSearchParamsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LearningSessionSearchParams, $Out>
    implements
        LearningSessionSearchParamsCopyWith<
          $R,
          LearningSessionSearchParams,
          $Out
        > {
  _LearningSessionSearchParamsCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<LearningSessionSearchParams> $mapper =
      LearningSessionSearchParamsMapper.ensureInitialized();
  @override
  $R call({
    Object? quizId = $none,
    Object? mode = $none,
    Object? keyword = $none,
    Object? isCompleted = $none,
    int? size,
    int? page,
  }) => $apply(
    FieldCopyWithData({
      if (quizId != $none) #quizId: quizId,
      if (mode != $none) #mode: mode,
      if (keyword != $none) #keyword: keyword,
      if (isCompleted != $none) #isCompleted: isCompleted,
      if (size != null) #size: size,
      if (page != null) #page: page,
    }),
  );
  @override
  LearningSessionSearchParams $make(CopyWithData data) =>
      LearningSessionSearchParams(
        quizId: data.get(#quizId, or: $value.quizId),
        mode: data.get(#mode, or: $value.mode),
        keyword: data.get(#keyword, or: $value.keyword),
        isCompleted: data.get(#isCompleted, or: $value.isCompleted),
        size: data.get(#size, or: $value.size),
        page: data.get(#page, or: $value.page),
      );

  @override
  LearningSessionSearchParamsCopyWith<$R2, LearningSessionSearchParams, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LearningSessionSearchParamsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

