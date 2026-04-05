import 'package:frontend/core/exceptions/app_exception.dart';
import 'package:frontend/core/services/object_box_service.dart';
import 'package:frontend/features/library/models/answer.dart';
import 'package:frontend/features/library/models/question.dart';
import 'package:frontend/objectbox.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'answer_repository.g.dart';

@riverpod
AnswerRepository answerRepository(Ref ref) {
  return AnswerRepository();
}

class AnswerRepository {
  final _db = ObjectBoxService.instance;
  final _answerBox = ObjectBoxService.instance.get<Answer>();
  final _questionBox = ObjectBoxService.instance.get<Question>();

  /// 1. Theo dõi danh sách đáp án (Real-time)
  Stream<List<Answer>> watchAnswersByQuestion(int questionId) {
    return _answerBox
        .query(Answer_.question.equals(questionId))
        .watch(triggerImmediately: true)
        .map((q) => q.find());
  }

  /// 2. Lấy danh sách đáp án (Async)
  Future<List<Answer>> getAnswersByQuestion(int questionId) {
    final query = _answerBox.query(Answer_.question.equals(questionId)).build();
    return query.findAsync();
  }

  /// 3. Lấy theo ID
  Future<Answer?> getAnswerById(int id) {
    return _answerBox.getAsync(id);
  }

  /// 4. Lưu hoặc cập nhật một đáp án lẻ
  Future<void> saveAnswer(int questionId, Answer answer) async {
    final question = await _questionBox.getAsync(questionId);
    if (question == null) {
      throw EntityNotFoundException('Câu hỏi không tồn tại.');
    }
    answer.question.target = question;
    await _answerBox.putAsync(answer);
  }

  /// 5. Cập nhật danh sách đáp án (Logic Orphan Removal quan trọng)
  Future<void> updateAnswers(int questionId, List<Answer> answers) async {
    // Sử dụng runInTransactionAsync để thực hiện một loạt thao tác an toàn
    await _db.store.runInTransactionAsync(TxMode.write, (
      Store store,
      List<dynamic> params,
    ) {
      final qBox = store.box<Question>();
      final aBox = store.box<Answer>();
      final qId = params[0] as int;
      final newAnswers = params[1] as List<Answer>;

      // 1. Kiểm tra Question cha
      final question = qBox.get(qId);
      if (question == null) throw Exception('Câu hỏi không tồn tại.');

      // 2. Logic Xóa những cái cũ không còn trong danh sách mới
      final query = aBox.query(Answer_.question.equals(qId)).build();
      final existingIds = query.find().map((a) => a.id).toSet();
      query.close();

      final incomingIds = newAnswers
          .map((a) => a.id)
          .where((id) => id != 0)
          .toSet();
      final idsToDelete = existingIds.difference(incomingIds);

      if (idsToDelete.isNotEmpty) {
        aBox.removeMany(idsToDelete.toList());
      }

      // 3. Upsert: Gán lại relation và lưu
      for (var answer in newAnswers) {
        answer.question.target = question;
      }
      aBox.putMany(newAnswers);

      // Lưu ý: Trong ObjectBox, putMany vào Box Answer là đủ để cập nhật relation.
      // Không cần gọi question.answers.save() như Isar.
    }, [questionId, answers]);
  }

  /// 6. Xóa một đáp án
  Future<void> deleteAnswer(int answerId) async {
    final success = await _answerBox.removeAsync(answerId);
    if (!success) {
      throw EntityNotFoundException('Đáp án không tồn tại hoặc đã bị xóa.');
    }
  }

  /// 7. Xóa sạch đáp án của một câu hỏi
  Future<void> deleteAnswersByQuestion(int questionId) async {
    final query = _answerBox.query(Answer_.question.equals(questionId)).build();
    await query.removeAsync();
    query.close();
  }
}
