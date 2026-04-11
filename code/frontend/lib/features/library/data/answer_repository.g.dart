// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(answerRepository)
final answerRepositoryProvider = AnswerRepositoryProvider._();

final class AnswerRepositoryProvider
    extends
        $FunctionalProvider<
          AnswerRepository,
          AnswerRepository,
          AnswerRepository
        >
    with $Provider<AnswerRepository> {
  AnswerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'answerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$answerRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnswerRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnswerRepository create(Ref ref) {
    return answerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnswerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnswerRepository>(value),
    );
  }
}

String _$answerRepositoryHash() => r'2f605700886229ed6e55cb5f9132363459d3b169';
