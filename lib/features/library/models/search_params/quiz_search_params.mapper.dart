// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'quiz_search_params.dart';

class QuizSearchParamsMapper extends ClassMapperBase<QuizSearchParams> {
  QuizSearchParamsMapper._();

  static QuizSearchParamsMapper? _instance;
  static QuizSearchParamsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuizSearchParamsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuizSearchParams';

  static int _$subjectId(QuizSearchParams v) => v.subjectId;
  static const Field<QuizSearchParams, int> _f$subjectId = Field(
    'subjectId',
    _$subjectId,
  );
  static String? _$keyword(QuizSearchParams v) => v.keyword;
  static const Field<QuizSearchParams, String> _f$keyword = Field(
    'keyword',
    _$keyword,
    opt: true,
  );
  static int _$size(QuizSearchParams v) => v.size;
  static const Field<QuizSearchParams, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
    def: 10,
  );
  static int _$page(QuizSearchParams v) => v.page;
  static const Field<QuizSearchParams, int> _f$page = Field(
    'page',
    _$page,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<QuizSearchParams> fields = const {
    #subjectId: _f$subjectId,
    #keyword: _f$keyword,
    #size: _f$size,
    #page: _f$page,
  };

  static QuizSearchParams _instantiate(DecodingData data) {
    return QuizSearchParams(
      subjectId: data.dec(_f$subjectId),
      keyword: data.dec(_f$keyword),
      size: data.dec(_f$size),
      page: data.dec(_f$page),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuizSearchParams fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuizSearchParams>(map);
  }

  static QuizSearchParams fromJson(String json) {
    return ensureInitialized().decodeJson<QuizSearchParams>(json);
  }
}

mixin QuizSearchParamsMappable {
  String toJson() {
    return QuizSearchParamsMapper.ensureInitialized()
        .encodeJson<QuizSearchParams>(this as QuizSearchParams);
  }

  Map<String, dynamic> toMap() {
    return QuizSearchParamsMapper.ensureInitialized()
        .encodeMap<QuizSearchParams>(this as QuizSearchParams);
  }

  QuizSearchParamsCopyWith<QuizSearchParams, QuizSearchParams, QuizSearchParams>
  get copyWith =>
      _QuizSearchParamsCopyWithImpl<QuizSearchParams, QuizSearchParams>(
        this as QuizSearchParams,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return QuizSearchParamsMapper.ensureInitialized().stringifyValue(
      this as QuizSearchParams,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuizSearchParamsMapper.ensureInitialized().equalsValue(
      this as QuizSearchParams,
      other,
    );
  }

  @override
  int get hashCode {
    return QuizSearchParamsMapper.ensureInitialized().hashValue(
      this as QuizSearchParams,
    );
  }
}

extension QuizSearchParamsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuizSearchParams, $Out> {
  QuizSearchParamsCopyWith<$R, QuizSearchParams, $Out>
  get $asQuizSearchParams =>
      $base.as((v, t, t2) => _QuizSearchParamsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class QuizSearchParamsCopyWith<$R, $In extends QuizSearchParams, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? subjectId, String? keyword, int? size, int? page});
  QuizSearchParamsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _QuizSearchParamsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuizSearchParams, $Out>
    implements QuizSearchParamsCopyWith<$R, QuizSearchParams, $Out> {
  _QuizSearchParamsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuizSearchParams> $mapper =
      QuizSearchParamsMapper.ensureInitialized();
  @override
  $R call({int? subjectId, Object? keyword = $none, int? size, int? page}) =>
      $apply(
        FieldCopyWithData({
          if (subjectId != null) #subjectId: subjectId,
          if (keyword != $none) #keyword: keyword,
          if (size != null) #size: size,
          if (page != null) #page: page,
        }),
      );
  @override
  QuizSearchParams $make(CopyWithData data) => QuizSearchParams(
    subjectId: data.get(#subjectId, or: $value.subjectId),
    keyword: data.get(#keyword, or: $value.keyword),
    size: data.get(#size, or: $value.size),
    page: data.get(#page, or: $value.page),
  );

  @override
  QuizSearchParamsCopyWith<$R2, QuizSearchParams, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _QuizSearchParamsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

