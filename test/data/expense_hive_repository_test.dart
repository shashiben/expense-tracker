import 'dart:io';

import 'package:expense_tracker/app/app.constants.dart';
import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/data/repository/expense_hive_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;
  late ExpenseHiveRepository repo;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('expense_hive_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(ExpenseModelAdapter());
  });

  setUp(() async {
    if (Hive.isBoxOpen(AppDbConstants.expensesBox)) {
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).clear();
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).close();
    }
    await Hive.openBox<ExpenseModel>(AppDbConstants.expensesBox);
    repo = ExpenseHiveRepository();
  });

  tearDown(() async {
    if (Hive.isBoxOpen(AppDbConstants.expensesBox)) {
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).clear();
      await Hive.box<ExpenseModel>(AppDbConstants.expensesBox).close();
    }
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  ExpenseModel expense({
    required String title,
    String category = 'Food',
    double amount = 10,
    DateTime? date,
    List<String> tags = const [],
  }) => ExpenseModel(
    title: title,
    category: category,
    amount: amount,
    date: date ?? DateTime(2024, 1, 1),
    tags: tags,
  );

  test('create, read, update, delete, listAll', () async {
    final id = await repo.create(expense(title: 'A'));
    final read1 = await repo.read(id);
    expect(read1?.title, 'A');

    await repo.update(id, expense(title: 'B'));
    final read2 = await repo.read(id);
    expect(read2?.title, 'B');

    final all = await repo.listAll();
    expect(all.length, 1);
    expect(all.first.key, id);

    await repo.delete(id);
    final none = await repo.read(id);
    expect(none, isNull);
  });

  test('search by title and category', () async {
    await repo.create(expense(title: 'Lunch', category: 'Food'));
    await repo.create(expense(title: 'Uber', category: 'Travel'));

    final res1 = await repo.search('lun');
    expect(res1.length, 1);
    expect(res1.first.value.title, 'Lunch');

    final res2 = await repo.search('travel');
    expect(res2.length, 1);
    expect(res2.first.value.category, 'Travel');
  });

  test('filter by category and tagsAny', () async {
    await repo
        .create(expense(title: 'A', category: 'Food', tags: ['work']))
        .then(
          (_) => repo.create(
            expense(title: 'B', category: 'Food', tags: ['home']),
          ),
        );
    await repo.create(expense(title: 'C', category: 'Bills', tags: ['urgent']));

    final onlyFood = await repo.filter(category: 'Food');
    expect(onlyFood.length, 2);

    final hasWorkOrUrgent = await repo.filter(tagsAny: ['work', 'urgent']);
    expect(hasWorkOrUrgent.length, 2);
  });

  test('sortByDate ascending/descending', () async {
    await repo.create(expense(title: 'Old', date: DateTime(2023, 1, 1)));
    await repo.create(expense(title: 'New', date: DateTime(2024, 1, 1)));

    final desc = await repo.sortByDate(descending: true);
    expect(desc.first.value.title, 'New');

    final asc = await repo.sortByDate(descending: false);
    expect(asc.first.value.title, 'Old');
  });

  test('clear', () async {
    await repo.create(expense(title: 'X'));
    await repo.clear();
    final all = await repo.listAll();
    expect(all, isEmpty);
  });
}
