// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnswerNotifier)
final answerProvider = AnswerNotifierFamily._();

final class AnswerNotifierProvider
    extends $StreamNotifierProvider<AnswerNotifier, List<Answer>> {
  AnswerNotifierProvider._({
    required AnswerNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'answerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$answerNotifierHash();

  @override
  String toString() {
    return r'answerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnswerNotifier create() => AnswerNotifier();

  @override
  bool operator ==(Object other) {
    return other is AnswerNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$answerNotifierHash() => r'ad2efb206ee5b3cc69fc137fba20e9c958392ad6';

final class AnswerNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AnswerNotifier,
          AsyncValue<List<Answer>>,
          List<Answer>,
          Stream<List<Answer>>,
          int
        > {
  AnswerNotifierFamily._()
    : super(
        retry: null,
        name: r'answerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnswerNotifierProvider call(int questionId) =>
      AnswerNotifierProvider._(argument: questionId, from: this);

  @override
  String toString() => r'answerProvider';
}

abstract class _$AnswerNotifier extends $StreamNotifier<List<Answer>> {
  late final _$args = ref.$arg as int;
  int get questionId => _$args;

  Stream<List<Answer>> build(int questionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Answer>>, List<Answer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Answer>>, List<Answer>>,
              AsyncValue<List<Answer>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
