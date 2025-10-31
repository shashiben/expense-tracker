import 'package:expense_tracker/ui/dialogs/filter/filter_dialog.dart';
import 'package:expense_tracker/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType { filter }

void setUpDialogUi() {
  final DialogService dialogService = locator<DialogService>();
  final builders = {
    DialogType.filter: (context, DialogRequest<dynamic> request, completer) =>
        FilterDialog(request: request, completer: completer),
  };
  dialogService.registerCustomDialogBuilders(builders);
}
