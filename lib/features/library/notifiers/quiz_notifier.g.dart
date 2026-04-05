// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizNotifier)
final quizProvider = QuizNotifierFamily._();

final class QuizNotifierProvider
    extends $StreamNotifierProvider<QuizNotifier, List<Quiz>> {
  QuizNotifierProvider._({
    required QuizNotifierFamily super.from,
    required QuizSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'quizProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quizNotifierHash();

  @override
  String toString() {
    return r'quizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QuizNotifier create() => QuizNotifier();

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizNotifierHash() => r'75f114686908ce2ccf267468352dd14a118ea6b9';

final class QuizNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          QuizNotifier,
          AsyncValue<List<Quiz>>,
          List<Quiz>,
          Stream<List<Quiz>>,
          QuizSearchParams
        > {
  QuizNotifierFamily._()
    : super(
        retry: null,
        name: r'quizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizNotifierProvider call(QuizSearchParams params) =>
      QuizNotifierProvider._(argument: params, from: this);

  @override
  String toString() => r'quizProvider';
}

abstract class _$QuizNotifier extends $StreamNotifier<List<Quiz>> {
  late final _$args = ref.$arg as QuizSearchParams;
  QuizSearchParams get params => _$args;

  Stream<List<Quiz>> build(QuizSearchParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Quiz>>, List<Quiz>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Quiz>>, List<Quiz>>,
              AsyncValue<List<Quiz>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(quizTotalPages)
final quizTotalPagesProvider = QuizTotalPagesFamily._();

final class QuizTotalPagesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  QuizTotalPagesProvider._({
    required QuizTotalPagesFamily super.from,
    required QuizSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'quizTotalPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quizTotalPagesHash();

  @override
  String toString() {
    return r'quizTotalPagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as QuizSearchParams;
    return quizTotalPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizTotalPagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quizTotalPagesHash() => r'b8622f26ce4cdf279899ca9f3fe31048ec41efaf';

final class QuizTotalPagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, QuizSearchParams> {
  QuizTotalPagesFamily._()
    : super(
        retry: null,
        name: r'quizTotalPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuizTotalPagesProvider call(QuizSearchParams params) =>
      QuizTotalPagesProvider._(argument: params, from: this);

  @override
  String toString() => r'quizTotalPagesProvider';
}

@ProviderFor(watchQuiz)
final watchQuizProvider = WatchQuizFamily._();

final class WatchQuizProvider
    extends $FunctionalProvider<AsyncValue<Quiz?>, Quiz?, Stream<Quiz?>>
    with $FutureModifier<Quiz?>, $StreamProvider<Quiz?> {
  WatchQuizProvider._({
    required WatchQuizFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchQuizProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchQuizHash();

  @override
  String toString() {
    return r'watchQuizProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Quiz?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Quiz?> create(Ref ref) {
    final argument = this.argument as int;
    return watchQuiz(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchQuizProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchQuizHash() => r'85b20df142c660fd0ca79b50ff3998d77256540b';

final class WatchQuizFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Quiz?>, int> {
  WatchQuizFamily._()
    : super(
        retry: null,
        name: r'watchQuizProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchQuizProvider call(int id) =>
      WatchQuizProvider._(argument: id, from: this);

  @override
  String toString() => r'watchQuizProvider';
}
