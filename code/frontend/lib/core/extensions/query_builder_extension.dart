import 'package:objectbox/objectbox.dart';

extension QueryBuilderExt<T> on QueryBuilder<T> {
  // Kết thúc query: Build -> Lấy ID -> Close (Tất cả trong 1 nốt nhạc)
  List<int> getIdsAndClose() {
    final query = build();
    try {
      return query.findIds();
    } finally {
      query.close();
    }
  }

  /// 2. RELATION XUÔI - ToOne (Ví dụ: Order -> User)
  QueryBuilder<T> safeLink<Target, V>(
    V? value,
    QueryRelationToOne<T, Target> rel,
    Condition<Target> Function(V) builder,
  ) {
    if (value == null || (value is String && value.isEmpty)) return this;
    return this..link(rel, builder(value));
  }

  /// 3. RELATION XUÔI - ToMany (Ví dụ: User -> Orders)
  QueryBuilder<T> safeLinkMany<Target, V>(
    V? value,
    QueryRelationToMany<T, Target> rel,
    Condition<Target> Function(V) builder,
  ) {
    if (value == null || (value is String && value.isEmpty)) return this;
    return this..linkMany(rel, builder(value));
  }

  /// 4. RELATION NGƯỢC - Backlink từ ToOne (Bảng khác trỏ về mình bằng ToOne)
  QueryBuilder<T> safeBacklink<Source, V>(
    V? value,
    QueryRelationToOne<Source, T> rel,
    Condition<Source> Function(V) builder,
  ) {
    if (value == null || (value is String && value.isEmpty)) return this;
    return this..backlink(rel, builder(value));
  }

  /// 5. RELATION NGƯỢC - Backlink từ ToMany (Bảng khác trỏ về mình bằng ToMany)
  QueryBuilder<T> safeBacklinkMany<Source, V>(
    V? value,
    QueryRelationToMany<Source, T> rel,
    Condition<Source> Function(V) builder,
  ) {
    if (value == null || (value is String && value.isEmpty)) return this;
    return this..backlinkMany(rel, builder(value));
  }

  /// Build nhanh kèm phân trang
  Query<T> buildPaged({int? limit, int? offset}) {
    return build()
      ..limit = limit ?? 0
      ..offset = offset ?? 0;
  }
}
