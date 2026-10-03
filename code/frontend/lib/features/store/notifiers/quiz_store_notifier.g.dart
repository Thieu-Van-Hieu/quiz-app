// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_store_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(githubQuizSource)
final githubQuizSourceProvider = GithubQuizSourceProvider._();

final class GithubQuizSourceProvider
    extends
        $FunctionalProvider<
          GithubQuizSource,
          GithubQuizSource,
          GithubQuizSource
        >
    with $Provider<GithubQuizSource> {
  GithubQuizSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'githubQuizSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$githubQuizSourceHash();

  @$internal
  @override
  $ProviderElement<GithubQuizSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GithubQuizSource create(Ref ref) {
    return githubQuizSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GithubQuizSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GithubQuizSource>(value),
    );
  }
}

String _$githubQuizSourceHash() => r'1df05ab4755567a3cd6e1c53f27909ce3a9cb5ad';

@ProviderFor(QuizStoreNotifier)
final quizStoreProvider = QuizStoreNotifierProvider._();

final class QuizStoreNotifierProvider
    extends $AsyncNotifierProvider<QuizStoreNotifier, QuizStoreData> {
  QuizStoreNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizStoreNotifierHash();

  @$internal
  @override
  QuizStoreNotifier create() => QuizStoreNotifier();
}

String _$quizStoreNotifierHash() => r'0e8b488c7bd2249e88a6319716fc176a028ad3c5';

abstract class _$QuizStoreNotifier extends $AsyncNotifier<QuizStoreData> {
  FutureOr<QuizStoreData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<QuizStoreData>, QuizStoreData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QuizStoreData>, QuizStoreData>,
              AsyncValue<QuizStoreData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
