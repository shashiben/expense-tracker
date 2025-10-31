import 'package:expense_tracker/ui/models/filter_options.dart';
import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                // Keep dialog minimal: search stays in the dashboard field
                const SizedBox(height: 16),
                Text('Category', style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: viewModel.selectedCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: viewModel.categories
                            .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          viewModel.selectedCategory = v;
                          viewModel.notifyListeners();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<SortBy>(
                        value: viewModel.sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Sort by',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: SortBy.date, child: Text('Date')),
                          DropdownMenuItem(value: SortBy.category, child: Text('Category')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          viewModel.sortBy = v;
                          viewModel.notifyListeners();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          completer(DialogResponse(confirmed: false)),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
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

String _sortValue(SortBy sortBy, bool desc) {
  if (sortBy == SortBy.date) return desc ? 'date_desc' : 'date_asc';
  return desc ? 'cat_desc' : 'cat_asc';
}

String _currentSortLabel(SortBy sortBy, bool desc) {
  switch (_sortValue(sortBy, desc)) {
    case 'date_desc':
      return 'Date • Newest first';
    case 'date_asc':
      return 'Date • Oldest first';
    case 'cat_asc':
      return 'Category • A–Z';
    case 'cat_desc':
      return 'Category • Z–A';
  }
  return '';
}
