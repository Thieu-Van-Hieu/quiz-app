import 'package:dart_mappable/dart_mappable.dart';

part 'learning_mode.mapper.dart';

@MappableEnum()
enum LearningMode {
  @MappableValue('STUDY')
  study,
  @MappableValue('PRACTICE')
  practice,
  @MappableValue('EXAM')
  exam;

  String get label {
    switch (this) {
      case LearningMode.study:
        return "Học tập";
      case LearningMode.practice:
        return "Luyện tập";
      case LearningMode.exam:
        return "Thi cử";
    }
  }

  static LearningMode? fromString(String? value) {
    try {
      if (value == null) return null;
      return LearningModeMapper.fromValue(value.toUpperCase());
    } catch (_) {
      return null;
    }
  }

  static LearningMode fromValue(String value) {
    return LearningModeMapper.fromValue(value.toUpperCase());
  }
}
