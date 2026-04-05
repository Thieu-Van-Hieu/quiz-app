// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'question_search_params.dart';

class QuestionSearchParamsMapper extends ClassMapperBase<QuestionSearchParams> {
  QuestionSearchParamsMapper._();

  static QuestionSearchParamsMapper? _instance;
  static QuestionSearchParamsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = QuestionSearchParamsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'QuestionSearchParams';

  static int _$quizId(QuestionSearchParams v) => v.quizId;
  static const Field<QuestionSearchParams, int> _f$quizId = Field(
    'quizId',
    _$quizId,
  );
  static String? _$keyword(QuestionSearchParams v) => v.keyword;
  static const Field<QuestionSearchParams, String> _f$keyword = Field(
    'keyword',
    _$keyword,
    opt: true,
  );
  static int _$size(QuestionSearchParams v) => v.size;
  static const Field<QuestionSearchParams, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
    def: 20,
  );
  static int _$page(QuestionSearchParams v) => v.page;
  static const Field<QuestionSearchParams, int> _f$page = Field(
    'page',
    _$page,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<QuestionSearchParams> fields = const {
    #quizId: _f$quizId,
    #keyword: _f$keyword,
    #size: _f$size,
    #page: _f$page,
  };

  static QuestionSearchParams _instantiate(DecodingData data) {
    return QuestionSearchParams(
      quizId: data.dec(_f$quizId),
      keyword: data.dec(_f$keyword),
      size: data.dec(_f$size),
      page: data.dec(_f$page),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static QuestionSearchParams fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<QuestionSearchParams>(map);
  }

  static QuestionSearchParams fromJson(String json) {
    return ensureInitialized().decodeJson<QuestionSearchParams>(json);
  }
}

mixin QuestionSearchParamsMappable {
  String toJson() {
    return QuestionSearchParamsMapper.ensureInitialized()
        .encodeJson<QuestionSearchParams>(this as QuestionSearchParams);
  }

  Map<String, dynamic> toMap() {
    return QuestionSearchParamsMapper.ensureInitialized()
        .encodeMap<QuestionSearchParams>(this as QuestionSearchParams);
  }

  QuestionSearchParamsCopyWith<
    QuestionSearchParams,
    QuestionSearchParams,
    QuestionSearchParams
  >
  get copyWith =>
      _QuestionSearchParamsCopyWithImpl<
        QuestionSearchParams,
        QuestionSearchParams
      >(this as QuestionSearchParams, $identity, $identity);
  @override
  String toString() {
    return QuestionSearchParamsMapper.ensureInitialized().stringifyValue(
      this as QuestionSearchParams,
    );
  }

  @override
  bool operator ==(Object other) {
    return QuestionSearchParamsMapper.ensureInitialized().equalsValue(
      this as QuestionSearchParams,
      other,
    );
  }

  @override
  int get hashCode {
    return QuestionSearchParamsMapper.ensureInitialized().hashValue(
      this as QuestionSearchParams,
    );
  }
}

extension QuestionSearchParamsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, QuestionSearchParams, $Out> {
  QuestionSearchParamsCopyWith<$R, QuestionSearchParams, $Out>
  get $asQuestionSearchParams => $base.as(
    (v, t, t2) => _QuestionSearchParamsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class QuestionSearchParamsCopyWith<
  $R,
  $In extends QuestionSearchParams,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? quizId, String? keyword, int? size, int? page});
  QuestionSearchParamsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _QuestionSearchParamsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, QuestionSearchParams, $Out>
    implements QuestionSearchParamsCopyWith<$R, QuestionSearchParams, $Out> {
  _QuestionSearchParamsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<QuestionSearchParams> $mapper =
      QuestionSearchParamsMapper.ensureInitialized();
  @override
  $R call({int? quizId, Object? keyword = $none, int? size, int? page}) =>
      $apply(
        FieldCopyWithData({
          if (quizId != null) #quizId: quizId,
          if (keyword != $none) #keyword: keyword,
          if (size != null) #size: size,
          if (page != null) #page: page,
        }),
      );
  @override
  QuestionSearchParams $make(CopyWithData data) => QuestionSearchParams(
    quizId: data.get(#quizId, or: $value.quizId),
    keyword: data.get(#keyword, or: $value.keyword),
    size: data.get(#size, or: $value.size),
    page: data.get(#page, or: $value.page),
  );

  @override
  QuestionSearchParamsCopyWith<$R2, QuestionSearchParams, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _QuestionSearchParamsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

