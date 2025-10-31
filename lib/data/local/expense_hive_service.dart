import 'package:hive_ce/hive.dart';
import 'package:expense_tracker/data/models/expense.dart';

class ExpenseHiveService {
  static const String _boxName = 'expenses';

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(_boxName);

  Future<void> addExpense(ExpenseModel expense) async {
    await _box.add(expense);
  }

  List<ExpenseModel> getAllExpenses() {
    return _box.values.toList(growable: false);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
