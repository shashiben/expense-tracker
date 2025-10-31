import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/core/services/bottom_sheet.service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  Future<void> showAddExpenseSheet() async {
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addExpense,
    );
  }
}
