// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_tools_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizToolsNotifier)
final quizToolsProvider = QuizToolsNotifierProvider._();

final class QuizToolsNotifierProvider
    extends $NotifierProvider<QuizToolsNotifier, void> {
  QuizToolsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizToolsNotifierHash();

  @$internal
  @override
  QuizToolsNotifier create() => QuizToolsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$quizToolsNotifierHash() => r'af49fbcca8b9d613db71afecadcaeffeb32962a0';

abstract class _$QuizToolsNotifier extends $Notifier<void> {
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
