// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'search_options.dart';

class SearchCaseModeMapper extends EnumMapper<SearchCaseMode> {
  SearchCaseModeMapper._();

  static SearchCaseModeMapper? _instance;
  static SearchCaseModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SearchCaseModeMapper._());
    }
    return _instance!;
  }

  static SearchCaseMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SearchCaseMode decode(dynamic value) {
    switch (value) {
      case r'smart':
        return SearchCaseMode.smart;
      case r'ignore':
        return SearchCaseMode.ignore;
      case r'sensitive':
        return SearchCaseMode.sensitive;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SearchCaseMode self) {
    switch (self) {
      case SearchCaseMode.smart:
        return r'smart';
      case SearchCaseMode.ignore:
        return r'ignore';
      case SearchCaseMode.sensitive:
        return r'sensitive';
    }
  }
}

extension SearchCaseModeMapperExtension on SearchCaseMode {
  String toValue() {
    SearchCaseModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SearchCaseMode>(this) as String;
  }
}

class SearchMatchModeMapper extends EnumMapper<SearchMatchMode> {
  SearchMatchModeMapper._();

  static SearchMatchModeMapper? _instance;
  static SearchMatchModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SearchMatchModeMapper._());
    }
    return _instance!;
  }

  static SearchMatchMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SearchMatchMode decode(dynamic value) {
    switch (value) {
      case r'contains':
        return SearchMatchMode.contains;
      case r'wholeWord':
        return SearchMatchMode.wholeWord;
      case r'allWords':
        return SearchMatchMode.allWords;
      case r'fuzzy':
        return SearchMatchMode.fuzzy;
      case r'regex':
        return SearchMatchMode.regex;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SearchMatchMode self) {
    switch (self) {
      case SearchMatchMode.contains:
        return r'contains';
      case SearchMatchMode.wholeWord:
        return r'wholeWord';
      case SearchMatchMode.allWords:
        return r'allWords';
      case SearchMatchMode.fuzzy:
        return r'fuzzy';
      case SearchMatchMode.regex:
        return r'regex';
    }
  }
}

extension SearchMatchModeMapperExtension on SearchMatchMode {
  String toValue() {
    SearchMatchModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SearchMatchMode>(this) as String;
  }
}

class SearchOptionsMapper extends ClassMapperBase<SearchOptions> {
  SearchOptionsMapper._();

  static SearchOptionsMapper? _instance;
  static SearchOptionsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SearchOptionsMapper._());
      SearchCaseModeMapper.ensureInitialized();
      SearchMatchModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SearchOptions';

  static SearchCaseMode _$caseMode(SearchOptions v) => v.caseMode;
  static const Field<SearchOptions, SearchCaseMode> _f$caseMode = Field(
    'caseMode',
    _$caseMode,
    opt: true,
    def: SearchCaseMode.smart,
  );
  static SearchMatchMode _$matchMode(SearchOptions v) => v.matchMode;
  static const Field<SearchOptions, SearchMatchMode> _f$matchMode = Field(
    'matchMode',
    _$matchMode,
    opt: true,
    def: SearchMatchMode.contains,
  );
  static bool _$ignoreDiacritics(SearchOptions v) => v.ignoreDiacritics;
  static const Field<SearchOptions, bool> _f$ignoreDiacritics = Field(
    'ignoreDiacritics',
    _$ignoreDiacritics,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SearchOptions> fields = const {
    #caseMode: _f$caseMode,
    #matchMode: _f$matchMode,
    #ignoreDiacritics: _f$ignoreDiacritics,
  };

  static SearchOptions _instantiate(DecodingData data) {
    return SearchOptions(
      caseMode: data.dec(_f$caseMode),
      matchMode: data.dec(_f$matchMode),
      ignoreDiacritics: data.dec(_f$ignoreDiacritics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SearchOptions fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SearchOptions>(map);
  }

  static SearchOptions fromJson(String json) {
    return ensureInitialized().decodeJson<SearchOptions>(json);
  }
}

mixin SearchOptionsMappable {
  String toJson() {
    return SearchOptionsMapper.ensureInitialized().encodeJson<SearchOptions>(
      this as SearchOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return SearchOptionsMapper.ensureInitialized().encodeMap<SearchOptions>(
      this as SearchOptions,
    );
  }

  SearchOptionsCopyWith<SearchOptions, SearchOptions, SearchOptions>
  get copyWith => _SearchOptionsCopyWithImpl<SearchOptions, SearchOptions>(
    this as SearchOptions,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SearchOptionsMapper.ensureInitialized().stringifyValue(
      this as SearchOptions,
    );
  }

  @override
  bool operator ==(Object other) {
    return SearchOptionsMapper.ensureInitialized().equalsValue(
      this as SearchOptions,
      other,
    );
  }

  @override
  int get hashCode {
    return SearchOptionsMapper.ensureInitialized().hashValue(
      this as SearchOptions,
    );
  }
}

extension SearchOptionsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SearchOptions, $Out> {
  SearchOptionsCopyWith<$R, SearchOptions, $Out> get $asSearchOptions =>
      $base.as((v, t, t2) => _SearchOptionsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SearchOptionsCopyWith<$R, $In extends SearchOptions, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    SearchCaseMode? caseMode,
    SearchMatchMode? matchMode,
    bool? ignoreDiacritics,
  });
  SearchOptionsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SearchOptionsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SearchOptions, $Out>
    implements SearchOptionsCopyWith<$R, SearchOptions, $Out> {
  _SearchOptionsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SearchOptions> $mapper =
      SearchOptionsMapper.ensureInitialized();
  @override
  $R call({
    SearchCaseMode? caseMode,
    SearchMatchMode? matchMode,
    bool? ignoreDiacritics,
  }) => $apply(
    FieldCopyWithData({
      if (caseMode != null) #caseMode: caseMode,
      if (matchMode != null) #matchMode: matchMode,
      if (ignoreDiacritics != null) #ignoreDiacritics: ignoreDiacritics,
    }),
  );
  @override
  SearchOptions $make(CopyWithData data) => SearchOptions(
    caseMode: data.get(#caseMode, or: $value.caseMode),
    matchMode: data.get(#matchMode, or: $value.matchMode),
    ignoreDiacritics: data.get(#ignoreDiacritics, or: $value.ignoreDiacritics),
  );

  @override
  SearchOptionsCopyWith<$R2, SearchOptions, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SearchOptionsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

