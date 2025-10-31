import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/domain/repository/crud_repository.dart';

abstract class ExpenseRepository extends CrudRepository<ExpenseModel, int> {
  Future<List<MapEntry<int, ExpenseModel>>> search(String query);
  Future<List<MapEntry<int, ExpenseModel>>> filter({
    String? category,
    List<String>? tagsAny,
  });
  Future<List<MapEntry<int, ExpenseModel>>> sortByDate({
    bool descending = true,
  });
}
