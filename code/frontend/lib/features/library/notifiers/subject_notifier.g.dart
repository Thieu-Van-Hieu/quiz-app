// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubjectNotifier)
final subjectProvider = SubjectNotifierProvider._();

final class SubjectNotifierProvider
    extends $NotifierProvider<SubjectNotifier, void> {
  SubjectNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subjectProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subjectNotifierHash();

  @$internal
  @override
  SubjectNotifier create() => SubjectNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$subjectNotifierHash() => r'90d399e52cccb83d6cdb306d87b1e8cd36ef661c';

abstract class _$SubjectNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(watchSubjects)
final watchSubjectsProvider = WatchSubjectsFamily._();

final class WatchSubjectsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Subject>>,
          List<Subject>,
          Stream<List<Subject>>
        >
    with $FutureModifier<List<Subject>>, $StreamProvider<List<Subject>> {
  WatchSubjectsProvider._({
    required WatchSubjectsFamily super.from,
    required SubjectSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchSubjectsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchSubjectsHash();

  @override
  String toString() {
    return r'watchSubjectsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Subject>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Subject>> create(Ref ref) {
    final argument = this.argument as SubjectSearchParams;
    return watchSubjects(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchSubjectsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchSubjectsHash() => r'a14abd9a7bcfadd6d0d91d1b76148fabf5a615de';

final class WatchSubjectsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Subject>>, SubjectSearchParams> {
  WatchSubjectsFamily._()
    : super(
        retry: null,
        name: r'watchSubjectsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchSubjectsProvider call(SubjectSearchParams params) =>
      WatchSubjectsProvider._(argument: params, from: this);

  @override
  String toString() => r'watchSubjectsProvider';
}

@ProviderFor(watchSubjectTotalPages)
final watchSubjectTotalPagesProvider = WatchSubjectTotalPagesFamily._();

final class WatchSubjectTotalPagesProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  WatchSubjectTotalPagesProvider._({
    required WatchSubjectTotalPagesFamily super.from,
    required SubjectSearchParams super.argument,
  }) : super(
         retry: null,
         name: r'watchSubjectTotalPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchSubjectTotalPagesHash();

  @override
  String toString() {
    return r'watchSubjectTotalPagesProvider'
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
    return watchSubjectTotalPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchSubjectTotalPagesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchSubjectTotalPagesHash() =>
    r'b66b8ecf21c68c5d03f4a772e5c99eb49ba125c1';

final class WatchSubjectTotalPagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, SubjectSearchParams> {
  WatchSubjectTotalPagesFamily._()
    : super(
        retry: null,
        name: r'watchSubjectTotalPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchSubjectTotalPagesProvider call(SubjectSearchParams params) =>
      WatchSubjectTotalPagesProvider._(argument: params, from: this);

  @override
  String toString() => r'watchSubjectTotalPagesProvider';
}
