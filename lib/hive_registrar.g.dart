import 'package:hive_ce/hive.dart';
import 'package:expense_tracker/data/models/expense.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(ExpenseModelAdapter());
  }
}

extension IsolatedHiveRegistrar on IsolatedHiveInterface {
  void registerAdapters() {
    registerAdapter(ExpenseModelAdapter());
  }
}
