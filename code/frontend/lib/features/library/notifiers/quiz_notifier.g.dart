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

String _$quizNotifierHash() => r'6675f434706cc74838ddfc6a789c90179eb4b41c';

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

@ProviderFor(watchQuizTotalPages)
final watchQuizTotalPagesProvider = WatchQuizTotalPagesFamily._();

final class WatchQuizTotalPagesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  WatchQuizTotalPagesProvider._({
    required WatchQuizTotalPagesFamily super.from,
    required QuizSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchQuizTotalPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchQuizTotalPagesHash();

  @override
  String toString() {
    return r'watchQuizTotalPagesProvider'
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
    return watchQuizTotalPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchQuizTotalPagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchQuizTotalPagesHash() =>
    r'a04b82adb03cb8da0ee35b1c861906258224f1fc';

final class WatchQuizTotalPagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, QuizSearchParams> {
  WatchQuizTotalPagesFamily._()
    : super(
        retry: null,
        name: r'watchQuizTotalPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchQuizTotalPagesProvider call(QuizSearchParams params) =>
      WatchQuizTotalPagesProvider._(argument: params, from: this);

  @override
  String toString() => r'watchQuizTotalPagesProvider';
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

@ProviderFor(watchQuizzes)
final watchQuizzesProvider = WatchQuizzesFamily._();

final class WatchQuizzesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Quiz>>,
          List<Quiz>,
          Stream<List<Quiz>>
        >
    with $FutureModifier<List<Quiz>>, $StreamProvider<List<Quiz>> {
  WatchQuizzesProvider._({
    required WatchQuizzesFamily super.from,
    required QuizSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchQuizzesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchQuizzesHash();

  @override
  String toString() {
    return r'watchQuizzesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Quiz>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Quiz>> create(Ref ref) {
    final argument = this.argument as QuizSearchParams;
    return watchQuizzes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchQuizzesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchQuizzesHash() => r'5942aed2317db724a4a90d860878a6611a9f319b';

final class WatchQuizzesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Quiz>>, QuizSearchParams> {
  WatchQuizzesFamily._()
    : super(
        retry: null,
        name: r'watchQuizzesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchQuizzesProvider call(QuizSearchParams params) =>
      WatchQuizzesProvider._(argument: params, from: this);

  @override
  String toString() => r'watchQuizzesProvider';
}
