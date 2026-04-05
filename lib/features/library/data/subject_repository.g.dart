// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(subjectRepository)
final subjectRepositoryProvider = SubjectRepositoryProvider._();

final class SubjectRepositoryProvider
    extends
        $FunctionalProvider<
          SubjectRepository,
          SubjectRepository,
          SubjectRepository
        >
    with $Provider<SubjectRepository> {
  SubjectRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subjectRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subjectRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubjectRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubjectRepository create(Ref ref) {
    return subjectRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubjectRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubjectRepository>(value),
    );
  }
}

String _$subjectRepositoryHash() => r'6e5e9989ddff7367e31a3a818f96f5b71211a755';
