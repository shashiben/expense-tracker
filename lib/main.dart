import 'package:expense_tracker/app/app.router.dart';
import 'package:expense_tracker/app/app.theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'core/services/init_service.dart';

void main() async {
  await initAppServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: lightThemeData,
      navigatorKey: StackedService.navigatorKey,
      initialRoute: Routes.dashboardScreen,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
