import 'package:dart_mappable/dart_mappable.dart';

part 'shortcut_action.mapper.dart';

@MappableEnum()
enum ShortcutAction {
  nextQuestion("Câu tiếp theo"),
  previousQuestion("Câu trước đó"),
  toggleQuestion("Hiện đáp án"),
  checkQuestion("Kiểm tra đáp án");

  final String label;

  const ShortcutAction(this.label);
}
