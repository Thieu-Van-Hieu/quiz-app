// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuestionNotifier)
final questionProvider = QuestionNotifierFamily._();

final class QuestionNotifierProvider
    extends $AsyncNotifierProvider<QuestionNotifier, List<Question>> {
  QuestionNotifierProvider._({
    required QuestionNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'questionProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$questionNotifierHash();

  @override
  String toString() {
    return r'questionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuestionNotifier create() => QuestionNotifier();

  @override
  bool operator ==(Object other) {
    return other is QuestionNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$questionNotifierHash() => r'de95bb1cb194ae27d88fd677affc4b3ac775d9dd';

final class QuestionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          QuestionNotifier,
          AsyncValue<List<Question>>,
          List<Question>,
          FutureOr<List<Question>>,
          int
        > {
  QuestionNotifierFamily._()
    : super(
        retry: null,
        name: r'questionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  QuestionNotifierProvider call(int quizId) =>
      QuestionNotifierProvider._(argument: quizId, from: this);

  @override
  String toString() => r'questionProvider';
}

abstract class _$QuestionNotifier extends $AsyncNotifier<List<Question>> {
  late final _$args = ref.$arg as int;
  int get quizId => _$args;

  FutureOr<List<Question>> build(int quizId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Question>>, List<Question>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Question>>, List<Question>>,
              AsyncValue<List<Question>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
