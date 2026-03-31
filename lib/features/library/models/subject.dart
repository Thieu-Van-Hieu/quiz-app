import 'package:frontend/features/library/models/quiz.dart';
import 'package:isar/isar.dart';
part 'subject.g.dart';

@Collection(accessor: 'subjects')
class Subject {
  Id id = Isar.autoIncrement; // Auto-increment ID
  @Index(
    type: IndexType.value,
  ) // Tạo index trên trường code để tìm kiếm nhanh hơn
  late String code;
  @Index(
    type: IndexType.value,
  ) // Tạo index trên trường name để tìm kiếm nhanh hơn
  late String name;
  @Backlink(to: 'subject') // Định nghĩa backlink đến Quiz
  final quizzes = IsarLinks<Quiz>(); // Liên kết đến Quiz
}
