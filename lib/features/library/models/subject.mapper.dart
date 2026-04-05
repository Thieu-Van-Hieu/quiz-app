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

  SubjectCopyWith<Subject, Subject, Subject> get copyWith =>
      _SubjectCopyWithImpl<Subject, Subject>(
        this as Subject,
        $identity,
        $identity,
      );
}

extension SubjectValueCopy<$R, $Out> on ObjectCopyWith<$R, Subject, $Out> {
  SubjectCopyWith<$R, Subject, $Out> get $asSubject =>
      $base.as((v, t, t2) => _SubjectCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SubjectCopyWith<$R, $In extends Subject, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? id, String? code, String? name});
  SubjectCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SubjectCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Subject, $Out>
    implements SubjectCopyWith<$R, Subject, $Out> {
  _SubjectCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Subject> $mapper =
      SubjectMapper.ensureInitialized();
  @override
  $R call({int? id, String? code, String? name}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (code != null) #code: code,
      if (name != null) #name: name,
    }),
  );
  @override
  Subject $make(CopyWithData data) => Subject(
    id: data.get(#id, or: $value.id),
    code: data.get(#code, or: $value.code),
    name: data.get(#name, or: $value.name),
  );

  @override
  SubjectCopyWith<$R2, Subject, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubjectCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

