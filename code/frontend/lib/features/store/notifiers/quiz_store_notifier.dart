import 'package:frontend/features/library/data/quiz_repository.dart';
import 'package:frontend/features/library/data/subject_repository.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/library/notifiers/quiz_notifier.dart';
import 'package:frontend/features/library/services/quiz/quiz_convert_service.dart';
import 'package:frontend/features/store/models/remote_quiz.dart';
import 'package:frontend/features/store/services/github_quiz_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_store_notifier.g.dart';

@riverpod
GithubQuizSource githubQuizSource(Ref ref) => GithubQuizSource();

@riverpod
class QuizStoreNotifier extends _$QuizStoreNotifier {
  @override
  Future<QuizStoreData> build() => ref.read(githubQuizSourceProvider).load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(githubQuizSourceProvider).load(),
    );
  }

  /// Tải file JSON từ GitHub và chuyển thành Quiz mới (chưa lưu)
  Future<Quiz> download(RemoteQuiz remote) async {
    final json = await ref.read(githubQuizSourceProvider).download(remote);
    try {
      return QuizConverterService.importAsNew(json);
    } catch (_) {
      throw RemoteSourceException(
        'File "${remote.fileName}" không đúng định dạng.',
      );
    }
  }

  /// Lưu quiz vào môn [subjectId], hoặc tạo môn mới với mã [newSubjectCode].
  /// Trả về id môn học đã lưu vào.
  Future<int> saveImported({
    required RemoteQuiz remote,
    required Quiz quiz,
    int? subjectId,
    String? newSubjectCode,
  }) async {
    final targetId = subjectId ?? await _ensureSubject(newSubjectCode!.trim());

    await validateAndSaveQuiz(ref.read(quizRepositoryProvider), targetId, quiz);

    final record = await ref
        .read(githubQuizSourceProvider)
        .markImported(remote);
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.withImport(remote.path, record));
    }
    return targetId;
  }

  /// Lấy id môn theo mã, chưa có thì tạo mới (tên tạm = mã môn)
  Future<int> _ensureSubject(String code) async {
    final repo = ref.read(subjectRepositoryProvider);
    final existing = await repo.getSubjectByCode(code);
    if (existing != null) return existing.id;

    await repo.saveSubject(Subject(code: code, name: code));
    final created = await repo.getSubjectByCode(code);
    return created!.id;
  }
}
