import 'package:expense_tracker/ui/screens/dashboard/dashboard.screen.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [StackedRoute(path: "/dashboard", page: DashboardScreen)],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
  ],
)
class AppState {}
