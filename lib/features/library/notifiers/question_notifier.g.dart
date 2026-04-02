// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionNotifierHash() => r'3e8c38156791db1ac52e7a826bcd8696db7929e9';

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

abstract class _$QuestionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Question>> {
  late final int quizId;

  FutureOr<List<Question>> build(
    int quizId,
  );
}

/// See also [QuestionNotifier].
@ProviderFor(QuestionNotifier)
const questionNotifierProvider = QuestionNotifierFamily();

/// See also [QuestionNotifier].
class QuestionNotifierFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [QuestionNotifier].
  const QuestionNotifierFamily();

  /// See also [QuestionNotifier].
  QuestionNotifierProvider call(
    int quizId,
  ) {
    return QuestionNotifierProvider(
      quizId,
    );
  }

  @override
  QuestionNotifierProvider getProviderOverride(
    covariant QuestionNotifierProvider provider,
  ) {
    return call(
      provider.quizId,
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
  String? get name => r'questionNotifierProvider';
}

/// See also [QuestionNotifier].
class QuestionNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    QuestionNotifier, List<Question>> {
  /// See also [QuestionNotifier].
  QuestionNotifierProvider(
    int quizId,
  ) : this._internal(
          () => QuestionNotifier()..quizId = quizId,
          from: questionNotifierProvider,
          name: r'questionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$questionNotifierHash,
          dependencies: QuestionNotifierFamily._dependencies,
          allTransitiveDependencies:
              QuestionNotifierFamily._allTransitiveDependencies,
          quizId: quizId,
        );

  QuestionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quizId,
  }) : super.internal();

  final int quizId;

  @override
  FutureOr<List<Question>> runNotifierBuild(
    covariant QuestionNotifier notifier,
  ) {
    return notifier.build(
      quizId,
    );
  }

  @override
  Override overrideWith(QuestionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuestionNotifierProvider._internal(
        () => create()..quizId = quizId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quizId: quizId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuestionNotifier, List<Question>>
      createElement() {
    return _QuestionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionNotifierProvider && other.quizId == quizId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quizId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuestionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Question>> {
  /// The parameter `quizId` of this provider.
  int get quizId;
}

class _QuestionNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuestionNotifier,
        List<Question>> with QuestionNotifierRef {
  _QuestionNotifierProviderElement(super.provider);

  @override
  int get quizId => (origin as QuestionNotifierProvider).quizId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
