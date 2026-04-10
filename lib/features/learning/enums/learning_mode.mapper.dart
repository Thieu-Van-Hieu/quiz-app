// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'learning_mode.dart';

class LearningModeMapper extends EnumMapper<LearningMode> {
  LearningModeMapper._();

  static LearningModeMapper? _instance;
  static LearningModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LearningModeMapper._());
    }
    return _instance!;
  }

  static LearningMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  LearningMode decode(dynamic value) {
    switch (value) {
      case 'STUDY':
        return LearningMode.study;
      case 'PRACTICE':
        return LearningMode.practice;
      case 'EXAM':
        return LearningMode.exam;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(LearningMode self) {
    switch (self) {
      case LearningMode.study:
        return 'STUDY';
      case LearningMode.practice:
        return 'PRACTICE';
      case LearningMode.exam:
        return 'EXAM';
    }
  }
}

extension LearningModeMapperExtension on LearningMode {
  dynamic toValue() {
    LearningModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<LearningMode>(this);
  }
}

