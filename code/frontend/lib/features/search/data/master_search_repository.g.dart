// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(masterSearchRepository)
final masterSearchRepositoryProvider = MasterSearchRepositoryProvider._();

final class MasterSearchRepositoryProvider
    extends
        $FunctionalProvider<
          MasterSearchRepository,
          MasterSearchRepository,
          MasterSearchRepository
        >
    with $Provider<MasterSearchRepository> {
  MasterSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masterSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masterSearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<MasterSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MasterSearchRepository create(Ref ref) {
    return masterSearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MasterSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MasterSearchRepository>(value),
    );
  }
}

String _$masterSearchRepositoryHash() =>
    r'ecfd7e6769d4c956481241874bd822f14a709f04';

@ProviderFor(watchSearchCorpus)
final watchSearchCorpusProvider = WatchSearchCorpusProvider._();

final class WatchSearchCorpusProvider
    extends
        $FunctionalProvider<
          AsyncValue<SearchCorpus>,
          SearchCorpus,
          Stream<SearchCorpus>
        >
    with $FutureModifier<SearchCorpus>, $StreamProvider<SearchCorpus> {
  WatchSearchCorpusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchSearchCorpusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchSearchCorpusHash();

  @$internal
  @override
  $StreamProviderElement<SearchCorpus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SearchCorpus> create(Ref ref) {
    return watchSearchCorpus(ref);
  }
}

String _$watchSearchCorpusHash() => r'f0a2c56c61c9ef5d60919e1f72d4ebacd312ca93';
