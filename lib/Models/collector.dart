abstract class Collector<T> {
  final List<T> items = [];

  Iterable<T> get visibleItems;

  void collectAll(List<T> newItems) {
    items.addAll(newItems);
  }

  void join(Collector<T> collector) {
    items.addAll(collector.items);
  }

  void removeMany(List<T> items) {
    this.items.removeWhere((item) => items.contains(item));
  }

  void remove(T item) {
    items.remove(item);
  }

  void removeUnnecessaryItems();
}
