import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/core/services/bottom_sheet.service.dart';
import 'package:expense_tracker/core/services/dialog.service.dart';
import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/data/repository/expense_hive_repository.dart';
import 'package:expense_tracker/ui/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/ui/models/filter_options.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:expense_tracker/app/app.constants.dart';

class DashboardViewModel extends BaseViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final _repo = ExpenseHiveRepository();
  final DialogService _dialogService = locator<DialogService>();

  final searchController = TextEditingController();
  final List<String> categories = AppConfig.defaultCategoryLabels;
  String selectedCategory = 'All';
  bool sortDesc = true;
  SortBy sortBy = SortBy.date;

  List<MapEntry<int, ExpenseModel>> _all = <MapEntry<int, ExpenseModel>>[];
  List<MapEntry<int, ExpenseModel>> visible = <MapEntry<int, ExpenseModel>>[];

  double get totalVisible =>
      visible.fold<double>(0, (sum, e) => sum + e.value.amount);

  List<GroupSection> get groupedSections {
    final Map<String, List<MapEntry<int, ExpenseModel>>> groups = {};
    for (final entry in visible) {
      final e = entry.value;
      final key = sortBy == SortBy.date
          ? DateUtilsX.formatYmd(e.date)
          : e.category;
      groups.putIfAbsent(key, () => <MapEntry<int, ExpenseModel>>[]).add(entry);
    }

    final sections = groups.entries
        .map((kv) => GroupSection(header: kv.key, items: kv.value))
        .toList();

    sections.sort((a, b) {
      if (sortBy == SortBy.date) {
        
        final ad = a.items.first.value.date;
        final bd = b.items.first.value.date;
        return ad.compareTo(bd);
      } else {
        return a.header.toLowerCase().compareTo(b.header.toLowerCase());
      }
    });
    return sortDesc ? sections.reversed.toList() : sections;
  }

  String sectionHeader(GroupSection section) {
    if (sortBy == SortBy.date && section.items.isNotEmpty) {
      return DateUtilsX.formatDayMonthNameYear(section.items.first.value.date);
    }
    return section.header;
  }

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
      isScrollControlled: true,
    );
    if (result?.confirmed == true && result?.data is ExpenseModel) {
      await _repo.create(result!.data as ExpenseModel);
      await load();
    }
  }

  Future<void> editEntry(MapEntry<int, ExpenseModel> entry) async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addExpense,
      data: entry,
      isScrollControlled: true,
    );
    if (result?.confirmed == true) {
      final data = result?.data;
      if (data is MapEntry<int, ExpenseModel>) {
        await _repo.update(data.key, data.value);
        await load();
      }
    }
  }

  Future<void> deleteEntry(MapEntry<int, ExpenseModel> entry) async {
    await _repo.delete(entry.key);
    await load();
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

class GroupSection {
  final String header;
  final List<MapEntry<int, ExpenseModel>> items;
  GroupSection({required this.header, required this.items});
}
