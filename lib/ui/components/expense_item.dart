import 'package:expense_tracker/data/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/app/app.constants.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseItem({
    super.key,
    required this.expense,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final e = expense;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: ListTile(
        leading: Builder(
          builder: (context) {
            final cat = AppConfig.resolveCategory(e.category);
            final bg =
                cat?.bgColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
            final ic = cat?.icon ?? Icons.account_balance_wallet_outlined;
            return CircleAvatar(
              radius: 22,
              backgroundColor: bg,
              child: Icon(ic, color: Theme.of(context).colorScheme.primary),
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(
          e.title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          e.category,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton<String>(
          elevation: 2,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  const Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit?.call();
            } else if (value == 'delete') {
              onDelete?.call();
            }
          },
        ),
      ),
    );
  }

  // Icon/color now resolved through AppConstants.resolveCategory
}
