abstract class Collector<T> {
  final List<T> items = [];

  Iterable<T> get visibleItems;

  void collectAll(List<T> items) {
    this.items.addAll(items);
  }

  void join(Collector<T> collector) {
    this.items.addAll(collector.items);
  }

  void removeMany(List<T> items) {
    this.items.removeWhere((item) => items.contains(item));
  }

  void remove(T item) {
    items.remove(item);
  }

  void removeUnnecessaryItems();
}
