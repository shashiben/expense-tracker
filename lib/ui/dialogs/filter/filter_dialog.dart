import 'package:expense_tracker/ui/models/filter_options.dart';
import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:expense_tracker/app/app.constants.dart';

class FilterDialogModel extends BaseViewModel {
  final TextEditingController searchController;
  final List<String> categories;
  String selectedCategory;
  SortBy sortBy;
  bool sortDesc;

  FilterDialogModel({
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.sortBy,
    required this.sortDesc,
  });
}

class FilterDialog extends StackedView<FilterDialogModel> {
  final DialogRequest<dynamic> request;
  final void Function(DialogResponse<dynamic> response) completer;

  const FilterDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    FilterDialogModel viewModel,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Filters', style: theme.textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          completer(DialogResponse(confirmed: false)),
                    ),
                  ],
                ),
                SizedBox(height: AppUIConstants.paddingLG),
                Text('Category', style: theme.textTheme.labelLarge),
                SizedBox(height: AppUIConstants.spacingSM),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: viewModel.selectedCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: viewModel.categories
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c,
                                child: Text(c),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          viewModel.selectedCategory = v;
                          viewModel.notifyListeners();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppUIConstants.paddingMD),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<SortBy>(
                        initialValue: viewModel.sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Sort by',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: SortBy.date,
                            child: Text('Date'),
                          ),
                          DropdownMenuItem(
                            value: SortBy.category,
                            child: Text('Category'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          viewModel.sortBy = v;
                          viewModel.notifyListeners();
                        },
                      ),
                    ),
                    SizedBox(width: AppUIConstants.spacingMD),
                    Tooltip(
                      message: viewModel.sortDesc ? 'Newest/Z–A' : 'Oldest/A–Z',
                      child: IconButton.filledTonal(
                        onPressed: () {
                          viewModel.sortDesc = !viewModel.sortDesc;
                          viewModel.notifyListeners();
                        },
                        icon: Icon(
                          viewModel.sortDesc ? Icons.south : Icons.north,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppUIConstants.paddingLG),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          completer(DialogResponse(confirmed: false)),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: AppUIConstants.spacingMD),
                    ElevatedButton(
                      onPressed: () {
                        final result = FilterOptions(
                          query: viewModel.searchController.text,
                          category: viewModel.selectedCategory,
                          sortBy: viewModel.sortBy,
                          sortDesc: viewModel.sortDesc,
                        );
                        completer(
                          DialogResponse(confirmed: true, data: result),
                        );
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  FilterDialogModel viewModelBuilder(BuildContext context) {
    final initial = request.data is FilterOptions
        ? request.data as FilterOptions
        : const FilterOptions(
            query: '',
            category: 'All',
            sortBy: SortBy.date,
            sortDesc: true,
          );
    final categories = request.customData is List<String>
        ? (request.customData as List<String>)
        : const <String>[
            'All',
            'Food',
            'Travel',
            'Bills',
            'Shopping',
            'Entertainment',
            'Health',
            'Other',
          ];
    return FilterDialogModel(
      searchController: TextEditingController(text: initial.query),
      categories: categories,
      selectedCategory: initial.category,
      sortBy: initial.sortBy,
      sortDesc: initial.sortDesc,
    );
  }
}
