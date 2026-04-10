// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LearningSessionDetailNotifier)
final learningSessionDetailProvider = LearningSessionDetailNotifierFamily._();

final class LearningSessionDetailNotifierProvider
    extends $NotifierProvider<LearningSessionDetailNotifier, void> {
  LearningSessionDetailNotifierProvider._({
    required LearningSessionDetailNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'learningSessionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$learningSessionDetailNotifierHash();

  @override
  String toString() {
    return r'learningSessionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LearningSessionDetailNotifier create() => LearningSessionDetailNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LearningSessionDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$learningSessionDetailNotifierHash() =>
    r'efe42c0f4fbfc589cd5b279df6198249fde81b8e';

final class LearningSessionDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LearningSessionDetailNotifier,
          void,
          void,
          void,
          int
        > {
  LearningSessionDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'learningSessionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LearningSessionDetailNotifierProvider call(int detailId) =>
      LearningSessionDetailNotifierProvider._(argument: detailId, from: this);

  @override
  String toString() => r'learningSessionDetailProvider';
}

abstract class _$LearningSessionDetailNotifier extends $Notifier<void> {
  late final _$args = ref.$arg as int;
  int get detailId => _$args;

  void build(int detailId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(watchLearningSessionDetail)
final watchLearningSessionDetailProvider = WatchLearningSessionDetailFamily._();

final class WatchLearningSessionDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LearningSessionDetail?>,
          LearningSessionDetail?,
          Stream<LearningSessionDetail?>
        >
    with
        $FutureModifier<LearningSessionDetail?>,
        $StreamProvider<LearningSessionDetail?> {
  WatchLearningSessionDetailProvider._({
    required WatchLearningSessionDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchLearningSessionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchLearningSessionDetailHash();

  @override
  String toString() {
    return r'watchLearningSessionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LearningSessionDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LearningSessionDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return watchLearningSessionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchLearningSessionDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchLearningSessionDetailHash() =>
    r'fcec66fe30547d0a5cf7d1db20781570f2c5569c';

final class WatchLearningSessionDetailFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LearningSessionDetail?>, int> {
  WatchLearningSessionDetailFamily._()
    : super(
        retry: null,
        name: r'watchLearningSessionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchLearningSessionDetailProvider call(int detailId) =>
      WatchLearningSessionDetailProvider._(argument: detailId, from: this);

  @override
  String toString() => r'watchLearningSessionDetailProvider';
}
