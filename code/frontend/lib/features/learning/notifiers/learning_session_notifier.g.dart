// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LearningSessionNotifier)
final learningSessionProvider = LearningSessionNotifierProvider._();

final class LearningSessionNotifierProvider
    extends $NotifierProvider<LearningSessionNotifier, void> {
  LearningSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningSessionNotifierHash();

  @$internal
  @override
  LearningSessionNotifier create() => LearningSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$learningSessionNotifierHash() =>
    r'bb406f5d0af3b86a49dbbcfe4880ec61d7fe2d26';

abstract class _$LearningSessionNotifier extends $Notifier<void> {
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

@ProviderFor(watchLearningSessions)
final watchLearningSessionsProvider = WatchLearningSessionsFamily._();

final class WatchLearningSessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LearningSession>>,
          List<LearningSession>,
          Stream<List<LearningSession>>
        >
    with
        $FutureModifier<List<LearningSession>>,
        $StreamProvider<List<LearningSession>> {
  WatchLearningSessionsProvider._({
    required WatchLearningSessionsFamily super.from,
    required LearningSessionSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchLearningSessionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchLearningSessionsHash();

  @override
  String toString() {
    return r'watchLearningSessionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<LearningSession>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LearningSession>> create(Ref ref) {
    final argument = this.argument as LearningSessionSearchParams;
    return watchLearningSessions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchLearningSessionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchLearningSessionsHash() =>
    r'104768999afbe235386295bd802ba4399462d9b5';

final class WatchLearningSessionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<LearningSession>>,
          LearningSessionSearchParams
        > {
  WatchLearningSessionsFamily._()
    : super(
        retry: null,
        name: r'watchLearningSessionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchLearningSessionsProvider call(LearningSessionSearchParams params) =>
      WatchLearningSessionsProvider._(argument: params, from: this);

  @override
  String toString() => r'watchLearningSessionsProvider';
}

@ProviderFor(watchLearningSession)
final watchLearningSessionProvider = WatchLearningSessionFamily._();

final class WatchLearningSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<LearningSession?>,
          LearningSession?,
          Stream<LearningSession?>
        >
    with $FutureModifier<LearningSession?>, $StreamProvider<LearningSession?> {
  WatchLearningSessionProvider._({
    required WatchLearningSessionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchLearningSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchLearningSessionHash();

  @override
  String toString() {
    return r'watchLearningSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LearningSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LearningSession?> create(Ref ref) {
    final argument = this.argument as int;
    return watchLearningSession(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchLearningSessionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchLearningSessionHash() =>
    r'09d2a44baea67b2d259b323baf2da0ab5d571277';

final class WatchLearningSessionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LearningSession?>, int> {
  WatchLearningSessionFamily._()
    : super(
        retry: null,
        name: r'watchLearningSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchLearningSessionProvider call(int id) =>
      WatchLearningSessionProvider._(argument: id, from: this);

  @override
  String toString() => r'watchLearningSessionProvider';
}

@ProviderFor(watchLearningSessionTotalPages)
final watchLearningSessionTotalPagesProvider =
    WatchLearningSessionTotalPagesFamily._();

final class WatchLearningSessionTotalPagesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  WatchLearningSessionTotalPagesProvider._({
    required WatchLearningSessionTotalPagesFamily super.from,
    required LearningSessionSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchLearningSessionTotalPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchLearningSessionTotalPagesHash();

  @override
  String toString() {
    return r'watchLearningSessionTotalPagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as LearningSessionSearchParams;
    return watchLearningSessionTotalPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchLearningSessionTotalPagesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchLearningSessionTotalPagesHash() =>
    r'58bc1a37e9fedc29fba5e43800be89a2061f4e91';

final class WatchLearningSessionTotalPagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, LearningSessionSearchParams> {
  WatchLearningSessionTotalPagesFamily._()
    : super(
        retry: null,
        name: r'watchLearningSessionTotalPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchLearningSessionTotalPagesProvider call(
    LearningSessionSearchParams params,
  ) => WatchLearningSessionTotalPagesProvider._(argument: params, from: this);

  @override
  String toString() => r'watchLearningSessionTotalPagesProvider';
}
