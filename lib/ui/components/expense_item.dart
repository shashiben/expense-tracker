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
    final ThemeData theme = Theme.of(context);
    return ListTile(
      minVerticalPadding: 0,
      dense: true,
      leading: Builder(
        builder: (context) {
          final cat = AppConfig.resolveCategory(expense.category);
          final bg = cat?.bgColor ?? theme.colorScheme.surfaceContainerHighest;
          final ic = cat?.icon ?? Icons.account_balance_wallet_outlined;
          return CircleAvatar(
            radius: AppUIConstants.radiusCircle,
            backgroundColor: bg,
            child: Icon(ic, color: theme.colorScheme.primary),
          );
        },
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppUIConstants.paddingMD,
        vertical: AppUIConstants.paddingSM,
      ),
      title: Text(
        expense.title,
        style: theme.textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        expense.category,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: AppUIConstants.iconSizeSM),
                const SizedBox(width: AppUIConstants.spacingMD),
                const Text('Edit'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: AppUIConstants.iconSizeSM,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: AppUIConstants.spacingMD),
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
    );
  }
}
