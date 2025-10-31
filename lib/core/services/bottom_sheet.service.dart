import 'package:expense_tracker/app/app.locator.dart';
import 'package:expense_tracker/ui/bottom_sheets/add_expense/add_expense_sheet.dart';
import 'package:stacked_services/stacked_services.dart';

enum BottomSheetType { addExpense }

void setUpBottomSheetUi() {
  final BottomSheetService bottomSheetService = locator<BottomSheetService>();
  final builders = {
    BottomSheetType.addExpense:
        (context, SheetRequest<dynamic> sheetRequest, completer) =>
            AddExpenseSheetBody(request: sheetRequest, completer: completer),
  };
  bottomSheetService.setCustomSheetBuilders(builders);
}
