import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:expense_tracker/ui/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DashboardScreen extends StackedView<DashboardViewModel> {
  const DashboardScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filters', style: themeData.textTheme.titleMedium),
                const SizedBox(height: 8),
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
                // Filters handled by dialog; only search is shown here
              ],
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: viewModel.load,
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.visible.isEmpty
                    ? const Center(child: Text('No expenses yet'))
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: viewModel.visible.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final entry = viewModel.visible[index];
                          final e = entry.value;
                          return ListTile(
                            title: Text(e.title),
                            subtitle: Text(
                              '${e.category} • ${DateUtilsX.formatYmd(e.date)}',
                            ),
                            trailing: Text(e.amount.toStringAsFixed(2)),
                          );
                        },
                      ),
              ),
            ),
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

// date formatting moved to DateUtilsX
