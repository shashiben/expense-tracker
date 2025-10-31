import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/core/services/dialog.service.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:expense_tracker/data/models/expense.dart';

import 'bottom_sheet.service.dart';

Future<void> initAppServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>('expenses');
  await setupLocator();
  setUpBottomSheetUi();
  setUpDialogUi();
}
