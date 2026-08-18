import 'package:dart_mappable/dart_mappable.dart';
import 'package:frontend/features/learning/enums/learning_mode.dart';

part 'learning_setting.mapper.dart';

@MappableClass(
  generateMethods:
      GenerateMethods.decode | GenerateMethods.encode | GenerateMethods.copy,
  caseStyle: CaseStyle.camelCase,
)
class LearningSetting with LearningSettingMappable {
  int fromIndex;
  int toIndex;
  bool shuffleQuestions;
  bool shuffleOptions;
  int reviewOffset;
  LearningMode learningMode;
  int? customTimeLimit;

  LearningSetting({
    this.fromIndex = 0,
    this.toIndex = 10,
    this.reviewOffset = 0,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.learningMode = LearningMode.practice,
    this.customTimeLimit,
  });

  // Tính số lượng câu thực tế dựa trên khoảng chọn
  int get actualTotal => (toIndex - fromIndex).abs() + 1;
}
