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
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppUIConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ),

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
