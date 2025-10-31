part of 'dashboard.screen.dart';

class DashboardListSection extends StatelessWidget {
  final DashboardViewModel viewModel;
  const DashboardListSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return RefreshIndicator(
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
                    final headerText = viewModel.sectionHeader(section);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppUIConstants.spacingMD,
                        AppUIConstants.paddingMD,
                        AppUIConstants.spacingMD,
                        AppUIConstants.spacingSM,
                      ),
                      child: Text(
                        headerText,
                        style: themeData.textTheme.titleMedium,
                      ),
                    );
                  }
                  cursor++;
                  final start = cursor;
                  final end = cursor + section.items.length;
                  if (index >= start && index < end) {
                    final entry = section.items[index - start];
                    final e = entry.value;
                    return ExpenseItem(
                      expense: e,
                      onEdit: () => viewModel.editEntry(entry),
                      onDelete: () => viewModel.deleteEntry(entry),
                    );
                  }
                  cursor = end;
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
