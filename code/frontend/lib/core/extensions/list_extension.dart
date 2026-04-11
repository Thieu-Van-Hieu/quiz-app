extension ListPagingExtension<T> on List<T> {
  List<T> paged(int page, int size) {
    final start = page * size;
    if (start >= length) return [];
    return skip(start).take(size).toList();
  }
}
