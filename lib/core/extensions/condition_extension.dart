import 'package:objectbox/objectbox.dart';

extension ConditionExtension<T> on Condition<T>? {
  /// Phép AND an toàn:
  /// Nếu value hợp lệ, tạo condition mới và nối bằng & (AND).
  /// Nếu condition hiện tại đang null, nó sẽ lấy condition mới làm gốc (Init).
  Condition<T>? safeAnd<V>(V? value, Condition<T> Function(V) builder) {
    if (value == null || (value is String && value.isEmpty)) return this;
    final newCond = builder(value);
    return (this == null) ? newCond : this! & newCond;
  }

  /// Phép OR an toàn:
  /// Nếu value hợp lệ, tạo condition mới và nối bằng | (OR).
  /// Nếu condition hiện tại đang null, nó sẽ lấy condition mới làm gốc (Init).
  Condition<T>? safeOr<V>(V? value, Condition<T> Function(V) builder) {
    if (value == null || (value is String && value.isEmpty)) return this;
    final newCond = builder(value);
    return (this == null) ? newCond : this! | newCond;
  }
}
