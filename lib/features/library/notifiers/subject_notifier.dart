import 'package:frontend/features/library/data/subject_repository.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subject_notifier.g.dart';

@riverpod
class SubjectNotifier extends _$SubjectNotifier {
  // Tạo instance của Repo (Dùng Provider để DI)
  @override
  Stream<List<Subject>> build() {
    final repo = ref.watch(subjectRepositoryProvider);
    // Chỉ cần trả về Stream từ Repo, UI sẽ tự lắng nghe
    return repo.watchAllSubjects();
  }

  // --- HÀM XỬ LÝ (Thay cho Service) ---
  Future<void> saveSubject(Subject subject) async {
    final repo = ref.read(subjectRepositoryProvider);
    await repo.saveSubject(subject);
  }

  Future<void> deleteSubject(int id) async {
    final repo = ref.read(subjectRepositoryProvider);
    await repo.deleteSubject(id);
  }
}
