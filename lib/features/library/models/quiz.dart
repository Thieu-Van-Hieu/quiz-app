import 'package:frontend/features/library/models/subject.dart';
import 'package:isar/isar.dart';
part 'quiz.g.dart';

@Collection(accessor: 'quizzes')
class Quiz {
  Id id = Isar.autoIncrement;
  late String name;
  List<Question>? questions;
  final subject = IsarLink<Subject>(); // Liên kết đến Subject
}

@embedded
class Question {
  late String content;
  List<String> options = [];
  List<int> correctOptions = [];
}
