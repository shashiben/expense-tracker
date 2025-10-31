import 'dart:io';

import 'package:expense_tracker/app/app.constants.dart';
import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('dashboard_vm_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(ExpenseModelAdapter());
    await setupLocator();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  ExpenseModel e({
    required String title,
    String category = 'Food',
    double amount = 10,
    DateTime? date,
  }) => ExpenseModel(
    title: title,
    category: category,
    amount: amount,
    date: date ?? DateTime(2024, 1, 1),
    tags: const [],
  );

  Future<void> seed(List<ExpenseModel> items) async {
    if (Hive.isBoxOpen(AppDbConstants.expensesBox)) {
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).clear();
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).close();
    }
    final box = await Hive.openBox<ExpenseModel>(AppDbConstants.expensesBox);
    for (final item in items) {
      await box.add(item);
    }
  }

  test('load() populates visible sorted by date desc by default', () async {
    await seed([
      e(title: 'Old', date: DateTime(2023, 1, 1), amount: 5),
      e(title: 'New', date: DateTime(2024, 1, 1), amount: 15),
    ]);

    final vm = DashboardViewModel();
    await vm.init();

    expect(vm.visible.length, 2);
    expect(vm.visible.first.value.title, 'New');
    expect(vm.totalVisible, 20);
  });

  test('search filters by title and category', () async {
    await seed([
      e(title: 'Lunch', category: 'Food'),
      e(title: 'Uber', category: 'Travel'),
    ]);
    final vm = DashboardViewModel();
    await vm.init();

    vm.searchController.text = 'lun';
    vm.onQueryChanged('lun');
    expect(vm.visible.length, 1);
    expect(vm.visible.first.value.title, 'Lunch');

    vm.searchController.text = 'travel';
    vm.onQueryChanged('travel');
    expect(vm.visible.length, 1);
    expect(vm.visible.first.value.category, 'Travel');
  });

  test('category filter works', () async {
    await seed([
      e(title: 'A', category: 'Food'),
      e(title: 'B', category: 'Bills'),
    ]);
    final vm = DashboardViewModel();
    await vm.init();

    vm.onCategoryChanged('Food');
    expect(vm.visible.length, 1);
    expect(vm.visible.first.value.category, 'Food');

    vm.onCategoryChanged('All');
    expect(vm.visible.length, 2);
  });

  test('sort by category asc/desc', () async {
    await seed([
      e(title: 'A', category: 'Travel'),
      e(title: 'B', category: 'Bills'),
    ]);
    final vm = DashboardViewModel();
    await vm.init();

    vm.onSortByChanged(SortBy.category);
    vm.sortDesc = false;
    vm.onSortByChanged(SortBy.category);
    expect(vm.visible.first.value.category, 'Bills');

    vm.toggleSort();
    expect(vm.visible.first.value.category, 'Travel');
  });

  test('groupedSections groups by date or category', () async {
    await seed([
      e(title: 'A', category: 'Food', date: DateTime(2024, 1, 1)),
      e(title: 'B', category: 'Food', date: DateTime(2024, 1, 1)),
      e(title: 'C', category: 'Bills', date: DateTime(2023, 12, 31)),
    ]);
    final vm = DashboardViewModel();
    await vm.init();

    final dateSections = vm.groupedSections;
    expect(dateSections.length, 2);

    vm.onSortByChanged(SortBy.category);
    final catSections = vm.groupedSections;
    expect(catSections.length, 2);
    expect(catSections.any((s) => s.header == 'Food'), isTrue);
    expect(catSections.any((s) => s.header == 'Bills'), isTrue);
  });
}
