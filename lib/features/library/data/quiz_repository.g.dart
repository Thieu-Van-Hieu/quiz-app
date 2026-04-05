// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quizRepository)
final quizRepositoryProvider = QuizRepositoryProvider._();

final class QuizRepositoryProvider
    extends $FunctionalProvider<QuizRepository, QuizRepository, QuizRepository>
    with $Provider<QuizRepository> {
  QuizRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuizRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuizRepository create(Ref ref) {
    return quizRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuizRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuizRepository>(value),
    );
  }
}

String _$quizRepositoryHash() => r'0b674b7a91614384cd47f1a35cbb595139a55518';
