// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'subject_search_params.dart';

class SubjectSearchParamsMapper extends ClassMapperBase<SubjectSearchParams> {
  SubjectSearchParamsMapper._();

  static SubjectSearchParamsMapper? _instance;
  static SubjectSearchParamsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubjectSearchParamsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubjectSearchParams';

  static String? _$keyword(SubjectSearchParams v) => v.keyword;
  static const Field<SubjectSearchParams, String> _f$keyword = Field(
    'keyword',
    _$keyword,
    opt: true,
  );
  static int _$size(SubjectSearchParams v) => v.size;
  static const Field<SubjectSearchParams, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
    def: 10,
  );
  static int _$page(SubjectSearchParams v) => v.page;
  static const Field<SubjectSearchParams, int> _f$page = Field(
    'page',
    _$page,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SubjectSearchParams> fields = const {
    #keyword: _f$keyword,
    #size: _f$size,
    #page: _f$page,
  };

  static SubjectSearchParams _instantiate(DecodingData data) {
    return SubjectSearchParams(
      keyword: data.dec(_f$keyword),
      size: data.dec(_f$size),
      page: data.dec(_f$page),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubjectSearchParams fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubjectSearchParams>(map);
  }

  static SubjectSearchParams fromJson(String json) {
    return ensureInitialized().decodeJson<SubjectSearchParams>(json);
  }
}

mixin SubjectSearchParamsMappable {
  String toJson() {
    return SubjectSearchParamsMapper.ensureInitialized()
        .encodeJson<SubjectSearchParams>(this as SubjectSearchParams);
  }

  Map<String, dynamic> toMap() {
    return SubjectSearchParamsMapper.ensureInitialized()
        .encodeMap<SubjectSearchParams>(this as SubjectSearchParams);
  }

  SubjectSearchParamsCopyWith<
    SubjectSearchParams,
    SubjectSearchParams,
    SubjectSearchParams
  >
  get copyWith =>
      _SubjectSearchParamsCopyWithImpl<
        SubjectSearchParams,
        SubjectSearchParams
      >(this as SubjectSearchParams, $identity, $identity);
  @override
  String toString() {
    return SubjectSearchParamsMapper.ensureInitialized().stringifyValue(
      this as SubjectSearchParams,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubjectSearchParamsMapper.ensureInitialized().equalsValue(
      this as SubjectSearchParams,
      other,
    );
  }

  @override
  int get hashCode {
    return SubjectSearchParamsMapper.ensureInitialized().hashValue(
      this as SubjectSearchParams,
    );
  }
}

extension SubjectSearchParamsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubjectSearchParams, $Out> {
  SubjectSearchParamsCopyWith<$R, SubjectSearchParams, $Out>
  get $asSubjectSearchParams => $base.as(
    (v, t, t2) => _SubjectSearchParamsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubjectSearchParamsCopyWith<
  $R,
  $In extends SubjectSearchParams,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? keyword, int? size, int? page});
  SubjectSearchParamsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubjectSearchParamsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubjectSearchParams, $Out>
    implements SubjectSearchParamsCopyWith<$R, SubjectSearchParams, $Out> {
  _SubjectSearchParamsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubjectSearchParams> $mapper =
      SubjectSearchParamsMapper.ensureInitialized();
  @override
  $R call({Object? keyword = $none, int? size, int? page}) => $apply(
    FieldCopyWithData({
      if (keyword != $none) #keyword: keyword,
      if (size != null) #size: size,
      if (page != null) #page: page,
    }),
  );
  @override
  SubjectSearchParams $make(CopyWithData data) => SubjectSearchParams(
    keyword: data.get(#keyword, or: $value.keyword),
    size: data.get(#size, or: $value.size),
    page: data.get(#page, or: $value.page),
  );

  @override
  SubjectSearchParamsCopyWith<$R2, SubjectSearchParams, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubjectSearchParamsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

