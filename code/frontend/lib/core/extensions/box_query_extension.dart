import 'package:frontend/objectbox.g.dart';

extension BoxQueryExtension<T> on Box<T> {
  /// Giúp build Query nhanh gọn kèm theo phân trang
  Query<T> buildPagedQuery(Condition<T>? condition, {int? limit, int? offset}) {
    final builder = query(condition);
    return builder.build()
      ..limit = limit ?? 0
      ..offset = offset ?? 0;
  }
}
