// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(learningSessionRepository)
final learningSessionRepositoryProvider = LearningSessionRepositoryProvider._();

final class LearningSessionRepositoryProvider
    extends
        $FunctionalProvider<
          LearningSessionRepository,
          LearningSessionRepository,
          LearningSessionRepository
        >
    with $Provider<LearningSessionRepository> {
  LearningSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningSessionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearningSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningSessionRepository create(Ref ref) {
    return learningSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningSessionRepository>(value),
    );
  }
}

String _$learningSessionRepositoryHash() =>
    r'fc7690a67e6715c467813ddffcefe3433fbb77d3';
