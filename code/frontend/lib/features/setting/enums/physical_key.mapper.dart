// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'physical_key.dart';

class PhysicalKeyMapper extends EnumMapper<PhysicalKey> {
  PhysicalKeyMapper._();

  static PhysicalKeyMapper? _instance;
  static PhysicalKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhysicalKeyMapper._());
    }
    return _instance!;
  }

  static PhysicalKey fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  PhysicalKey decode(dynamic value) {
    switch (value) {
      case r'enter':
        return PhysicalKey.enter;
      case r'space':
        return PhysicalKey.space;
      case r'arrowRight':
        return PhysicalKey.arrowRight;
      case r'arrowLeft':
        return PhysicalKey.arrowLeft;
      case r'mouseLeft':
        return PhysicalKey.mouseLeft;
      case r'mouseRight':
        return PhysicalKey.mouseRight;
      case r'mouseMiddle':
        return PhysicalKey.mouseMiddle;
      case r'mouseBack':
        return PhysicalKey.mouseBack;
      case r'mouseForward':
        return PhysicalKey.mouseForward;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(PhysicalKey self) {
    switch (self) {
      case PhysicalKey.enter:
        return r'enter';
      case PhysicalKey.space:
        return r'space';
      case PhysicalKey.arrowRight:
        return r'arrowRight';
      case PhysicalKey.arrowLeft:
        return r'arrowLeft';
      case PhysicalKey.mouseLeft:
        return r'mouseLeft';
      case PhysicalKey.mouseRight:
        return r'mouseRight';
      case PhysicalKey.mouseMiddle:
        return r'mouseMiddle';
      case PhysicalKey.mouseBack:
        return r'mouseBack';
      case PhysicalKey.mouseForward:
        return r'mouseForward';
    }
  }
}

extension PhysicalKeyMapperExtension on PhysicalKey {
  String toValue() {
    PhysicalKeyMapper.ensureInitialized();
    return MapperContainer.globals.toValue<PhysicalKey>(this) as String;
  }
}

