import 'package:frontend/core/services/isar_service.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'subject_repository.g.dart';

@riverpod
SubjectRepository subjectRepository(SubjectRepositoryRef ref) {
  return SubjectRepository();
}

class SubjectRepository {
  final _isar = IsarService.instance;
  Stream<List<Subject>> watchAllSubjects() {
    return _isar.subjects.where().anyId().watch(fireImmediately: true);
  }

  Future<Subject?> getSubjectById(int id) async {
    return await _isar.subjects.get(id);
  }

  Future<Subject?> getSubjectByCode(String code) async {
    return await _isar.subjects.filter().codeEqualTo(code).findFirst();
  }

  Future<void> saveSubject(Subject subject) async {
    await _isar.writeTxn(() async {
      await _isar.subjects.put(subject);
    });
  }

  Future<void> deleteSubject(int id) async {
    await _isar.writeTxn(() async {
      await _isar.quizzes
          .filter()
          .subject((subject) => subject.idEqualTo(id))
          .deleteAll();
      await _isar.subjects.delete(id);
    });
  }
}
