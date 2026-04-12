// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_config.dart';

class AppConfigMapper extends ClassMapperBase<AppConfig> {
  AppConfigMapper._();

  static AppConfigMapper? _instance;
  static AppConfigMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppConfigMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AppConfig';

  static int _$id(AppConfig v) => v.id;
  static const Field<AppConfig, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 1,
  );
  static String _$fontFamily(AppConfig v) => v.fontFamily;
  static const Field<AppConfig, String> _f$fontFamily = Field(
    'fontFamily',
    _$fontFamily,
    opt: true,
    def: AppStrings.defaultFontFamily,
  );
  static double _$fontSize(AppConfig v) => v.fontSize;
  static const Field<AppConfig, double> _f$fontSize = Field(
    'fontSize',
    _$fontSize,
    opt: true,
    def: AppStrings.defaultFontSize,
  );
  static bool _$enableQuickAnswer(AppConfig v) => v.enableQuickAnswer;
  static const Field<AppConfig, bool> _f$enableQuickAnswer = Field(
    'enableQuickAnswer',
    _$enableQuickAnswer,
    opt: true,
    def: true,
  );
  static bool _$isMouseEnabled(AppConfig v) => v.isMouseEnabled;
  static const Field<AppConfig, bool> _f$isMouseEnabled = Field(
    'isMouseEnabled',
    _$isMouseEnabled,
    opt: true,
    def: true,
  );
  static String _$internalKeyBindings(AppConfig v) => v.internalKeyBindings;
  static const Field<AppConfig, String> _f$internalKeyBindings = Field(
    'internalKeyBindings',
    _$internalKeyBindings,
    opt: true,
    def: '{}',
  );

  @override
  final MappableFields<AppConfig> fields = const {
    #id: _f$id,
    #fontFamily: _f$fontFamily,
    #fontSize: _f$fontSize,
    #enableQuickAnswer: _f$enableQuickAnswer,
    #isMouseEnabled: _f$isMouseEnabled,
    #internalKeyBindings: _f$internalKeyBindings,
  };

  static AppConfig _instantiate(DecodingData data) {
    return AppConfig(
      id: data.dec(_f$id),
      fontFamily: data.dec(_f$fontFamily),
      fontSize: data.dec(_f$fontSize),
      enableQuickAnswer: data.dec(_f$enableQuickAnswer),
      isMouseEnabled: data.dec(_f$isMouseEnabled),
      internalKeyBindings: data.dec(_f$internalKeyBindings),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AppConfig fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppConfig>(map);
  }

  static AppConfig fromJson(String json) {
    return ensureInitialized().decodeJson<AppConfig>(json);
  }
}

mixin AppConfigMappable {
  String toJson() {
    return AppConfigMapper.ensureInitialized().encodeJson<AppConfig>(
      this as AppConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return AppConfigMapper.ensureInitialized().encodeMap<AppConfig>(
      this as AppConfig,
    );
  }

  AppConfigCopyWith<AppConfig, AppConfig, AppConfig> get copyWith =>
      _AppConfigCopyWithImpl<AppConfig, AppConfig>(
        this as AppConfig,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AppConfigMapper.ensureInitialized().stringifyValue(
      this as AppConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    return AppConfigMapper.ensureInitialized().equalsValue(
      this as AppConfig,
      other,
    );
  }

  @override
  int get hashCode {
    return AppConfigMapper.ensureInitialized().hashValue(this as AppConfig);
  }
}

extension AppConfigValueCopy<$R, $Out> on ObjectCopyWith<$R, AppConfig, $Out> {
  AppConfigCopyWith<$R, AppConfig, $Out> get $asAppConfig =>
      $base.as((v, t, t2) => _AppConfigCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AppConfigCopyWith<$R, $In extends AppConfig, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? fontFamily,
    double? fontSize,
    bool? enableQuickAnswer,
    bool? isMouseEnabled,
    String? internalKeyBindings,
  });
  AppConfigCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppConfigCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppConfig, $Out>
    implements AppConfigCopyWith<$R, AppConfig, $Out> {
  _AppConfigCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppConfig> $mapper =
      AppConfigMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? fontFamily,
    double? fontSize,
    bool? enableQuickAnswer,
    bool? isMouseEnabled,
    String? internalKeyBindings,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (fontFamily != null) #fontFamily: fontFamily,
      if (fontSize != null) #fontSize: fontSize,
      if (enableQuickAnswer != null) #enableQuickAnswer: enableQuickAnswer,
      if (isMouseEnabled != null) #isMouseEnabled: isMouseEnabled,
      if (internalKeyBindings != null)
        #internalKeyBindings: internalKeyBindings,
    }),
  );
  @override
  AppConfig $make(CopyWithData data) => AppConfig(
    id: data.get(#id, or: $value.id),
    fontFamily: data.get(#fontFamily, or: $value.fontFamily),
    fontSize: data.get(#fontSize, or: $value.fontSize),
    enableQuickAnswer: data.get(
      #enableQuickAnswer,
      or: $value.enableQuickAnswer,
    ),
    isMouseEnabled: data.get(#isMouseEnabled, or: $value.isMouseEnabled),
    internalKeyBindings: data.get(
      #internalKeyBindings,
      or: $value.internalKeyBindings,
    ),
  );

  @override
  AppConfigCopyWith<$R2, AppConfig, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AppConfigCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

