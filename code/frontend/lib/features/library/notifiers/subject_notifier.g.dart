// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubjectNotifier)
final subjectProvider = SubjectNotifierFamily._();

final class SubjectNotifierProvider
    extends $StreamNotifierProvider<SubjectNotifier, List<Subject>> {
  SubjectNotifierProvider._({
    required SubjectNotifierFamily super.from,
    required SubjectSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'subjectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subjectNotifierHash();

  @override
  String toString() {
    return r'subjectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SubjectNotifier create() => SubjectNotifier();

  @override
  bool operator ==(Object other) {
    return other is SubjectNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subjectNotifierHash() => r'e96da10260ee806316c2eeb15aeb0feafca84ced';

final class SubjectNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SubjectNotifier,
          AsyncValue<List<Subject>>,
          List<Subject>,
          Stream<List<Subject>>,
          SubjectSearchParams
        > {
  SubjectNotifierFamily._()
    : super(
        retry: null,
        name: r'subjectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubjectNotifierProvider call(SubjectSearchParams params) =>
      SubjectNotifierProvider._(argument: params, from: this);

  @override
  String toString() => r'subjectProvider';
}

abstract class _$SubjectNotifier extends $StreamNotifier<List<Subject>> {
  late final _$args = ref.$arg as SubjectSearchParams;
  SubjectSearchParams get params => _$args;

  Stream<List<Subject>> build(SubjectSearchParams params);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Subject>>, List<Subject>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Subject>>, List<Subject>>,
              AsyncValue<List<Subject>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(subjectTotalPages)
final subjectTotalPagesProvider = SubjectTotalPagesFamily._();

final class SubjectTotalPagesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  SubjectTotalPagesProvider._({
    required SubjectTotalPagesFamily super.from,
    required SubjectSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'subjectTotalPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subjectTotalPagesHash();

  @override
  String toString() {
    return r'subjectTotalPagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as SubjectSearchParams;
    return subjectTotalPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectTotalPagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subjectTotalPagesHash() => r'37e2dd0726e29805453b1dc79f9cd2c2289a2a1d';

final class SubjectTotalPagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, SubjectSearchParams> {
  SubjectTotalPagesFamily._()
    : super(
        retry: null,
        name: r'subjectTotalPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubjectTotalPagesProvider call(SubjectSearchParams params) =>
      SubjectTotalPagesProvider._(argument: params, from: this);

  @override
  String toString() => r'subjectTotalPagesProvider';
}
