// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session_detail_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learningSessionDetailRepository)
final learningSessionDetailRepositoryProvider =
    LearningSessionDetailRepositoryProvider._();

final class LearningSessionDetailRepositoryProvider
    extends
        $FunctionalProvider<
          LearningSessionDetailRepository,
          LearningSessionDetailRepository,
          LearningSessionDetailRepository
        >
    with $Provider<LearningSessionDetailRepository> {
  LearningSessionDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningSessionDetailRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningSessionDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearningSessionDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningSessionDetailRepository create(Ref ref) {
    return learningSessionDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningSessionDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningSessionDetailRepository>(
        value,
      ),
    );
  }
}

String _$learningSessionDetailRepositoryHash() =>
    r'8e3b7133a8fcf28efac1d7e80b23610119682e13';
