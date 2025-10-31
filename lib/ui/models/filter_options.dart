import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';

class FilterOptions {
  final String query;
  final String category;
  final SortBy sortBy;
  final bool sortDesc;

  const FilterOptions({
    required this.query,
    required this.category,
    required this.sortBy,
    required this.sortDesc,
  });
}
