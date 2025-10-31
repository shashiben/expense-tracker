abstract class CrudRepository<T, K> {
  Future<K> create(T item);
  Future<T?> read(K key);
  Future<void> update(K key, T item);
  Future<void> delete(K key);
  Future<List<MapEntry<K, T>>> listAll();
  Future<void> clear();
}


