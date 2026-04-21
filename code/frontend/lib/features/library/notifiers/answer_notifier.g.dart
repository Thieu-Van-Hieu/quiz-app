// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnswerNotifier)
final answerProvider = AnswerNotifierProvider._();

final class AnswerNotifierProvider
    extends $NotifierProvider<AnswerNotifier, void> {
  AnswerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'answerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$answerNotifierHash();

  @$internal
  @override
  AnswerNotifier create() => AnswerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$answerNotifierHash() => r'490b792ab1f344f2fee9ab8be1430c31f0a00af9';

abstract class _$AnswerNotifier extends $Notifier<void> {
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

@ProviderFor(watchAnswersByQuestion)
final watchAnswersByQuestionProvider = WatchAnswersByQuestionFamily._();

final class WatchAnswersByQuestionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Answer>>,
          List<Answer>,
          Stream<List<Answer>>
        >
    with $FutureModifier<List<Answer>>, $StreamProvider<List<Answer>> {
  WatchAnswersByQuestionProvider._({
    required WatchAnswersByQuestionFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchAnswersByQuestionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchAnswersByQuestionHash();

  @override
  String toString() {
    return r'watchAnswersByQuestionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Answer>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Answer>> create(Ref ref) {
    final argument = this.argument as int;
    return watchAnswersByQuestion(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchAnswersByQuestionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchAnswersByQuestionHash() =>
    r'c0fb481e28e0f9a452249cd1056cf9eae9657b7d';

final class WatchAnswersByQuestionFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Answer>>, int> {
  WatchAnswersByQuestionFamily._()
    : super(
        retry: null,
        name: r'watchAnswersByQuestionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchAnswersByQuestionProvider call(int questionId) =>
      WatchAnswersByQuestionProvider._(argument: questionId, from: this);

  @override
  String toString() => r'watchAnswersByQuestionProvider';
}
