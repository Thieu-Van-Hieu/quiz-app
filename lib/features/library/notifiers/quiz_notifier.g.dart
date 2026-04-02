// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizNotifierHash() => r'6ab6416d79f7b7adfd406eb0e894cf757480951f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$QuizNotifier
    extends BuildlessAutoDisposeStreamNotifier<List<Quiz>> {
  late final int subjectId;

  Stream<List<Quiz>> build(
    int subjectId,
  );
}

/// See also [QuizNotifier].
@ProviderFor(QuizNotifier)
const quizNotifierProvider = QuizNotifierFamily();

/// See also [QuizNotifier].
class QuizNotifierFamily extends Family<AsyncValue<List<Quiz>>> {
  /// See also [QuizNotifier].
  const QuizNotifierFamily();

  /// See also [QuizNotifier].
  QuizNotifierProvider call(
    int subjectId,
  ) {
    return QuizNotifierProvider(
      subjectId,
    );
  }

  @override
  QuizNotifierProvider getProviderOverride(
    covariant QuizNotifierProvider provider,
  ) {
    return call(
      provider.subjectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizNotifierProvider';
}

/// See also [QuizNotifier].
class QuizNotifierProvider
    extends AutoDisposeStreamNotifierProviderImpl<QuizNotifier, List<Quiz>> {
  /// See also [QuizNotifier].
  QuizNotifierProvider(
    int subjectId,
  ) : this._internal(
          () => QuizNotifier()..subjectId = subjectId,
          from: quizNotifierProvider,
          name: r'quizNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$quizNotifierHash,
          dependencies: QuizNotifierFamily._dependencies,
          allTransitiveDependencies:
              QuizNotifierFamily._allTransitiveDependencies,
          subjectId: subjectId,
        );

  QuizNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.subjectId,
  }) : super.internal();

  final int subjectId;

  @override
  Stream<List<Quiz>> runNotifierBuild(
    covariant QuizNotifier notifier,
  ) {
    return notifier.build(
      subjectId,
    );
  }

  @override
  Override overrideWith(QuizNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizNotifierProvider._internal(
        () => create()..subjectId = subjectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        subjectId: subjectId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<QuizNotifier, List<Quiz>>
      createElement() {
    return _QuizNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizNotifierProvider && other.subjectId == subjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, subjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuizNotifierRef on AutoDisposeStreamNotifierProviderRef<List<Quiz>> {
  /// The parameter `subjectId` of this provider.
  int get subjectId;
}

class _QuizNotifierProviderElement
    extends AutoDisposeStreamNotifierProviderElement<QuizNotifier, List<Quiz>>
    with QuizNotifierRef {
  _QuizNotifierProviderElement(super.provider);

  @override
  int get subjectId => (origin as QuizNotifierProvider).subjectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
