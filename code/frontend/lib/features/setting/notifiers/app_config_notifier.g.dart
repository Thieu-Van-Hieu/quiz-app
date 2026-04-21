// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppConfigNotifier)
final appConfigProvider = AppConfigNotifierProvider._();

final class AppConfigNotifierProvider
    extends $NotifierProvider<AppConfigNotifier, void> {
  AppConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigNotifierHash();

  @$internal
  @override
  AppConfigNotifier create() => AppConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$appConfigNotifierHash() => r'2e95ff125bbacd2093b06c9a9e35fba3cb6a0e25';

abstract class _$AppConfigNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(watchAppConfig)
final watchAppConfigProvider = WatchAppConfigProvider._();

final class WatchAppConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppConfig?>,
          AppConfig?,
          Stream<AppConfig?>
        >
    with $FutureModifier<AppConfig?>, $StreamProvider<AppConfig?> {
  WatchAppConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchAppConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchAppConfigHash();

  @$internal
  @override
  $StreamProviderElement<AppConfig?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppConfig?> create(Ref ref) {
    return watchAppConfig(ref);
  }
}

String _$watchAppConfigHash() => r'2d8bdf0b4dbc48acdc1f9665425ca4a3ea3c0b69';
