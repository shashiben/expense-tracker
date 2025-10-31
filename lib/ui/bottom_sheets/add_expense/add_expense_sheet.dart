import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/ui/utils/date_utils.dart';
import 'package:expense_tracker/ui/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:expense_tracker/app/app.constants.dart';

import 'add_expense_sheet_model.dart';

class AddExpenseSheetBody extends StackedView<AddExpenseSheetModel> {
  final SheetRequest<dynamic> request;
  final void Function(SheetResponse<dynamic> response) completer;
  const AddExpenseSheetBody({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    AddExpenseSheetModel viewModel,
    Widget? child,
  ) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final theme = Theme.of(context);

    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppUIConstants.radiusXL),
        topRight: Radius.circular(AppUIConstants.radiusXL),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppUIConstants.paddingLG,
          right: AppUIConstants.paddingLG,
          top: AppUIConstants.paddingLG,
          bottom: AppUIConstants.paddingLG + viewInsets.bottom,
        ),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Add Expense', style: theme.textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => completer(SheetResponse(confirmed: false)),
                  ),
                ],
              ),
              SizedBox(height: AppUIConstants.spacingMD),
              TextFormField(
                controller: viewModel.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Lunch, Taxi, Groceries',
                ),
                validator: (v) =>
                    ValidationUtils.nonEmpty(v, fieldName: 'Title'),
              ),
              SizedBox(height: AppUIConstants.paddingMD),
              TextFormField(
                controller: viewModel.amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'e.g., 12.50',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) =>
                    ValidationUtils.positiveNumber(v, fieldName: 'Amount'),
              ),
              SizedBox(height: AppUIConstants.paddingMD),
              DropdownButtonFormField<String>(
                initialValue: viewModel.selectedCategory,
                items: viewModel.categories
                    .map(
                      (c) => DropdownMenuItem<String>(value: c, child: Text(c)),
                    )
                    .toList(),
                onChanged: viewModel.setCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Choose a category',
                ),
                validator: (v) =>
                    ValidationUtils.nonNull(v, fieldName: 'Category'),
              ),
              SizedBox(height: AppUIConstants.paddingMD),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: viewModel.tagController,
                      decoration: InputDecoration(
                        labelText: 'Add tag',
                        hintText: 'e.g., office, weekend',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: viewModel.addTag,
                          tooltip: 'Add tag',
                        ),
                      ),
                      onFieldSubmitted: (_) => viewModel.addTag(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppUIConstants.spacingMD),
              Wrap(
                spacing: AppUIConstants.spacingSM,
                runSpacing: -AppUIConstants.spacingSM,
                children: viewModel.tags
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        onDeleted: () => viewModel.removeTag(t),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: AppUIConstants.paddingMD),
              Row(
                children: [
                  Text(
                    'Date: ${DateUtilsX.formatYmd(viewModel.selectedDate)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(width: AppUIConstants.spacingMD),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: viewModel.selectedDate,
                        firstDate: DateTime(now.year - 5),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) viewModel.setDate(picked);
                    },
                    child: const Text('Change'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final valid =
                          viewModel.formKey.currentState?.validate() ?? false;
                      if (!valid) return;
                      final amount = double.parse(
                        viewModel.amountController.text.trim(),
                      );
                      final expense = ExpenseModel(
                        date: viewModel.selectedDate,
                        amount: amount,
                        category: viewModel.selectedCategory!,
                        title: viewModel.titleController.text.trim(),
                        tags: List<String>.from(viewModel.tags),
                      );
                      final data = request.data;
                      if (data is MapEntry<int, ExpenseModel>) {
                        completer(
                          SheetResponse(
                            confirmed: true,
                            data: MapEntry(data.key, expense),
                          ),
                        );
                      } else {
                        completer(
                          SheetResponse(confirmed: true, data: expense),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(AddExpenseSheetModel viewModel) {
    final data = request.data;
    if (data is MapEntry<int, ExpenseModel>) {
      final e = data.value;
      viewModel.initFromExpense(
        title: e.title,
        amount: e.amount,
        category: e.category,
        date: e.date,
        existingTags: e.tags,
      );
    } else if (data is ExpenseModel) {
      final e = data;
      viewModel.initFromExpense(
        title: e.title,
        amount: e.amount,
        category: e.category,
        date: e.date,
        existingTags: e.tags,
      );
    }
    super.onViewModelReady(viewModel);
  }

  @override
  AddExpenseSheetModel viewModelBuilder(BuildContext context) {
    return AddExpenseSheetModel();
  }
}
