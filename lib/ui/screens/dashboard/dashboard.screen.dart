import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:expense_tracker/app/app.constants.dart';
import 'package:expense_tracker/ui/utils/animation_extensions.dart';

import '../../components/expense_item.dart';
part 'dashboard.list_section.dart';

class DashboardScreen extends StackedView<DashboardViewModel> {
  const DashboardScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppUIConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppUIConstants.paddingLG),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withValues(alpha: .7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppUIConstants.radiusXL),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: AppUIConstants.iconSizeLG,
                      ),
                      SizedBox(width: AppUIConstants.spacingMD),
                      Expanded(
                        child: Text(
                          'Know where your money goes',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppUIConstants.paddingMD),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Expenses',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withValues(alpha: .8),
                            ),
                          ),
                          SizedBox(height: AppUIConstants.spacingXXS),
                          Text(
                            '${AppConfig.defaultCurrencySymbol}${viewModel.totalVisible.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${viewModel.visible.length}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppUIConstants.spacingXXS),
                          Text(
                            'Items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ).fadeSlide(delay: const Duration(milliseconds: 40)),
            SizedBox(height: AppUIConstants.paddingMD),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: viewModel.searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search by title or category',
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (viewModel.searchController.text.isNotEmpty)
                          IconButton(
                            tooltip: 'Clear',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              viewModel.searchController.clear();
                              viewModel.onQueryChanged('');
                            },
                          ),
                        IconButton(
                          tooltip: 'Open filters',
                          icon: const Icon(Icons.tune),
                          onPressed: viewModel.openFilterDialog,
                        ),
                      ],
                    ),
                  ),
                  onChanged: viewModel.onQueryChanged,
                ),
              ],
            ).fadeSlide(delay: const Duration(milliseconds: 120)),

            SizedBox(height: AppUIConstants.paddingMD),
            Expanded(child: DashboardListSection(viewModel: viewModel)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.showAddExpenseSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
    final vm = DashboardViewModel();
    vm.init();
    return vm;
  }
}
