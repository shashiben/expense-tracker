import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/core/services/bottom_sheet.service.dart';
import 'package:expense_tracker/core/services/dialog.service.dart';
import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/data/repository/expense_hive_repository.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/ui/models/filter_options.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final _repo = ExpenseHiveRepository();
  final DialogService _dialogService = locator<DialogService>();

  final searchController = TextEditingController();
  final List<String> categories = const <String>[
    'All',
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];
  String selectedCategory = 'All';
  bool sortDesc = true;
  SortBy sortBy = SortBy.date;

  List<MapEntry<int, ExpenseModel>> _all = <MapEntry<int, ExpenseModel>>[];
  List<MapEntry<int, ExpenseModel>> visible = <MapEntry<int, ExpenseModel>>[];

  double get totalVisible =>
      visible.fold<double>(0, (sum, e) => sum + e.value.amount);

  Future<void> init() async {
    await load();
  }

  Future<void> load() async {
    setBusy(true);
    _all = await _repo.listAll();
    _applyFilters();
    setBusy(false);
  }

  void onQueryChanged(String _) {
    _applyFilters();
  }

  void onCategoryChanged(String? value) {
    if (value == null) return;
    selectedCategory = value;
    _applyFilters();
    notifyListeners();
  }

  void toggleSort() {
    sortDesc = !sortDesc;
    _applyFilters();
    notifyListeners();
  }

  void onSortByChanged(SortBy value) {
    sortBy = value;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    final q = searchController.text.trim().toLowerCase();
    Iterable<MapEntry<int, ExpenseModel>> items = _all;

    if (q.isNotEmpty) {
      items = items.where(
        (e) =>
            e.value.title.toLowerCase().contains(q) ||
            e.value.category.toLowerCase().contains(q),
      );
    }

    if (selectedCategory != 'All') {
      items = items.where((e) => e.value.category == selectedCategory);
    }

    final list = items.toList();
    switch (sortBy) {
      case SortBy.date:
        list.sort((a, b) => a.value.date.compareTo(b.value.date));
        break;
      case SortBy.category:
        list.sort(
          (a, b) => a.value.category.toLowerCase().compareTo(
            b.value.category.toLowerCase(),
          ),
        );
        break;
    }
    visible = sortDesc ? list.reversed.toList() : list;
    notifyListeners();
  }

  Future<void> showAddExpenseSheet() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addExpense,
    );
    if (result?.confirmed == true && result?.data is ExpenseModel) {
      await _repo.create(result!.data as ExpenseModel);
      await load();
    }
  }

  Future<void> openFilterDialog() async {
    final initial = FilterOptions(
      query: searchController.text,
      category: selectedCategory,
      sortBy: sortBy,
      sortDesc: sortDesc,
    );
    final response = await _dialogService.showCustomDialog(
      variant: DialogType.filter,
      data: initial,
    );
    if (response?.confirmed == true && response?.data is FilterOptions) {
      final opts = response!.data as FilterOptions;
      searchController.text = opts.query;
      selectedCategory = opts.category;
      sortBy = opts.sortBy;
      sortDesc = opts.sortDesc;
      _applyFilters();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

enum SortBy { date, category }
