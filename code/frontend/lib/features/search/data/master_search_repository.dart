import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/features/library/models/quiz.dart';
import 'package:frontend/features/library/models/subject.dart';
import 'package:frontend/features/search/services/master_search_service.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'master_search_repository.g.dart';

@riverpod
MasterSearchRepository masterSearchRepository(Ref ref) {
  return MasterSearchRepository();
}

class MasterSearchRepository {
  final _db = ObjectBoxService.instance;

  /// Toàn bộ dữ liệu để tìm kiếm, tự cập nhật khi bất kỳ bảng liên quan thay đổi
  Stream<SearchCorpus> watchCorpus() {
    return _db
        .watchTables([
          _db.store.watch<Question>(),
          _db.store.watch<Answer>(),
          _db.store.watch<Quiz>(),
          _db.store.watch<Subject>(),
        ])
        .map((_) {
          final questions = _db.get<Question>().getAll();
          for (final q in questions) {
            q.answers.sort((a, b) => a.indexOrder.compareTo(b.indexOrder));
          }
          return SearchCorpus(
            questions: questions,
            quizzes: _db.get<Quiz>().getAll(),
            subjects: _db.get<Subject>().getAll(),
          );
        });
  }
}

@riverpod
Stream<SearchCorpus> watchSearchCorpus(Ref ref) {
  return ref.watch(masterSearchRepositoryProvider).watchCorpus();
}
