// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'shortcut_action.dart';

class ShortcutActionMapper extends EnumMapper<ShortcutAction> {
  ShortcutActionMapper._();

  static ShortcutActionMapper? _instance;
  static ShortcutActionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShortcutActionMapper._());
    }
    return _instance!;
  }

  static ShortcutAction fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ShortcutAction decode(dynamic value) {
    switch (value) {
      case r'nextQuestion':
        return ShortcutAction.nextQuestion;
      case r'previousQuestion':
        return ShortcutAction.previousQuestion;
      case r'toggleQuestion':
        return ShortcutAction.toggleQuestion;
      case r'checkQuestion':
        return ShortcutAction.checkQuestion;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ShortcutAction self) {
    switch (self) {
      case ShortcutAction.nextQuestion:
        return r'nextQuestion';
      case ShortcutAction.previousQuestion:
        return r'previousQuestion';
      case ShortcutAction.toggleQuestion:
        return r'toggleQuestion';
      case ShortcutAction.checkQuestion:
        return r'checkQuestion';
    }
  }
}

extension ShortcutActionMapperExtension on ShortcutAction {
  String toValue() {
    ShortcutActionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ShortcutAction>(this) as String;
  }
}

