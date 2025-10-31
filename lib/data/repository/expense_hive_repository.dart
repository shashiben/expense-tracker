import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/domain/repository/expense_repository.dart';
import 'package:hive_ce/hive.dart';

class ExpenseHiveRepository implements ExpenseRepository {
  static const String _boxName = 'expenses';

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(_boxName);

  @override
  Future<int> create(ExpenseModel item) async {
    final key = await _box.add(item);
    return key;
  }

  @override
  Future<ExpenseModel?> read(int key) async {
    return _box.get(key);
  }

  @override
  Future<void> update(int key, ExpenseModel item) async {
    await _box.put(key, item);
  }

  @override
  Future<void> delete(int key) async {
    await _box.delete(key);
  }

  @override
  Future<List<MapEntry<int, ExpenseModel>>> listAll() async {
    final keys = _box.keys.cast<int>();
    return keys
        .map((k) => MapEntry(k, _box.get(k) as ExpenseModel))
        .toList(growable: false);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<List<MapEntry<int, ExpenseModel>>> search(String query) async {
    final q = query.trim().toLowerCase();
    return listAll().then(
      (items) => items
          .where(
            (e) =>
                e.value.title.toLowerCase().contains(q) ||
                e.value.category.toLowerCase().contains(q),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<List<MapEntry<int, ExpenseModel>>> filter({
    String? category,
    List<String>? tagsAny,
  }) async {
    final items = await listAll();
    return items
        .where((e) {
          final catOk = category == null || e.value.category == category;
          final tagsOk =
              tagsAny == null || tagsAny.any((t) => e.value.tags.contains(t));
          return catOk && tagsOk;
        })
        .toList(growable: false);
  }

  @override
  Future<List<MapEntry<int, ExpenseModel>>> sortByDate({
    bool descending = true,
  }) async {
    final items = await listAll();
    items.sort((a, b) => a.value.date.compareTo(b.value.date));
    if (descending) {
      return items.reversed.toList(growable: false);
    }
    return items;
  }
}
