// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'subject.dart';

class SubjectMapper extends ClassMapperBase<Subject> {
  SubjectMapper._();

  static SubjectMapper? _instance;
  static SubjectMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubjectMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Subject';

  static int _$id(Subject v) => v.id;
  static const Field<Subject, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$code(Subject v) => v.code;
  static const Field<Subject, String> _f$code = Field('code', _$code);
  static String _$name(Subject v) => v.name;
  static const Field<Subject, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: '',
  );
  static ToMany<Quiz> _$quizzes(Subject v) => v.quizzes;
  static const Field<Subject, ToMany<Quiz>> _f$quizzes = Field(
    'quizzes',
    _$quizzes,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<Subject> fields = const {
    #id: _f$id,
    #code: _f$code,
    #name: _f$name,
    #quizzes: _f$quizzes,
  };

  static Subject _instantiate(DecodingData data) {
    return Subject(
      id: data.dec(_f$id),
      code: data.dec(_f$code),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Subject fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Subject>(map);
  }

  static Subject fromJson(String json) {
    return ensureInitialized().decodeJson<Subject>(json);
  }
}

mixin SubjectMappable {
  String toJson() {
    return SubjectMapper.ensureInitialized().encodeJson<Subject>(
      this as Subject,
    );
  }

  Map<String, dynamic> toMap() {
    return SubjectMapper.ensureInitialized().encodeMap<Subject>(
      this as Subject,
    );
  }
}

