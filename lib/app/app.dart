import 'package:expense_tracker/ui/screens/dashboard/dashboard.screen.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [StackedRoute(path: "/dashboard", page: DashboardScreen)],
  dependencies: [],
)
class AppState {}
