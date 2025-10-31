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

            Expanded(
              child: RefreshIndicator(
                onRefresh: viewModel.load,
                child: viewModel.isBusy
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.visible.isEmpty
                    ? const Center(child: Text('No expenses yet'))
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: viewModel.groupedSections.fold<int>(
                          0,
                          (n, s) => n + 1 + s.items.length,
                        ),
                        itemBuilder: (context, index) {
                          int cursor = 0;
                          for (final section in viewModel.groupedSections) {
                            if (index == cursor) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                                child: Text(
                                  section.header,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              );
                            }
                            cursor++;
                            final start = cursor;
                            final end = cursor + section.items.length;
                            if (index >= start && index < end) {
                              final entry = section.items[index - start];
                              final e = entry.value;
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          e.title,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        e.amount.toStringAsFixed(2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        '${e.category} • ${DateUtilsX.formatYmd(e.date)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                      if (e.tags.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          e.tags.join(', '),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    elevation: 2,
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        viewModel.editEntry(entry);
                                      } else if (value == 'delete') {
                                        viewModel.deleteEntry(entry);
                                      }
                                    },
                                  ),
                                ),
                              );
                            }
                            cursor = end;
                          }
                          return const SizedBox.shrink();
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
