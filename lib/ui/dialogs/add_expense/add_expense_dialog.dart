import 'package:expense_tracker/data/models/expense.dart';
import 'package:expense_tracker/ui/bottom_sheets/add_expense/add_expense_sheet_model.dart';
import 'package:expense_tracker/ui/utils/date_utils.dart';
import 'package:expense_tracker/ui/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:expense_tracker/app/app.constants.dart';
import 'package:expense_tracker/ui/utils/animation_extensions.dart';

class AddExpenseDialog extends StackedView<AddExpenseSheetModel> {
  final DialogRequest<dynamic> request;
  final void Function(DialogResponse<dynamic> response) completer;

  const AddExpenseDialog({
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
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppUIConstants.paddingLG,
        vertical: AppUIConstants.paddingXL,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radiusXL),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.paddingLG),
          child: Form(
            key: viewModel.formKey,
            child: SingleChildScrollView(
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
                        onPressed: () =>
                            completer(DialogResponse(confirmed: false)),
                      ),
                    ],
                  ).fadeSlide(beginOffset: const Offset(0, 12), delay: const Duration(milliseconds: 80)),
                  SizedBox(height: AppUIConstants.paddingMD),
                  TextFormField(
                    controller: viewModel.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., Lunch, Taxi, Groceries',
                    ),
                    validator: (v) =>
                        ValidationUtils.nonEmpty(v, fieldName: 'Title'),
                  ).fadeSlide(delay: const Duration(milliseconds: 140)),
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
                  ).fadeSlide(delay: const Duration(milliseconds: 180)),
                  SizedBox(height: AppUIConstants.paddingMD),
                  DropdownButtonFormField<String>(
                    initialValue: viewModel.selectedCategory,
                    items: viewModel.categories
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: viewModel.setCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      hintText: 'Choose a category',
                    ),
                    validator: (v) =>
                        ValidationUtils.nonNull(v, fieldName: 'Category'),
                  ).fadeSlide(delay: const Duration(milliseconds: 220)),
                  SizedBox(height: AppUIConstants.paddingMD),
                  TextFormField(
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
                  ).fadeSlide(delay: const Duration(milliseconds: 260)),
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
                  ).fadeIn(delay: const Duration(milliseconds: 300)),
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
                    ],
                  ).fadeSlide(delay: const Duration(milliseconds: 340)),
                  SizedBox(height: AppUIConstants.paddingLG),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () =>
                            completer(DialogResponse(confirmed: false)),
                        child: const Text('Cancel'),
                      ).fadeIn(delay: const Duration(milliseconds: 360)),
                      SizedBox(width: AppUIConstants.spacingMD),
                      ElevatedButton(
                        onPressed: () {
                          final valid =
                              viewModel.formKey.currentState?.validate() ??
                              false;
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
                          completer(
                            DialogResponse(confirmed: true, data: expense),
                          );
                        },
                        child: const Text('Save'),
                      ).fadeSlide(delay: const Duration(milliseconds: 400)),
                    ],
                  ),
                ],
              ).fadeSlide(beginOffset: const Offset(0, 18), delay: const Duration(milliseconds: 60)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  AddExpenseSheetModel viewModelBuilder(BuildContext context) =>
      AddExpenseSheetModel();
}
