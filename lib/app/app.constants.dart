import 'package:flutter/material.dart';

class AppDbConstants {
  static const String expensesBox = 'expenses';
}

enum ExpenseCategory {
  food(
    label: 'Food',
    icon: Icons.restaurant_outlined,
    bgColor: Color(0xFFFFE8E1),
  ),
  travel(
    label: 'Travel',
    icon: Icons.directions_car_outlined,
    bgColor: Color(0xFFE7F2FF),
  ),
  bills(
    label: 'Bills',
    icon: Icons.receipt_long_outlined,
    bgColor: Color(0xFFEFF0FF),
  ),
  shopping(
    label: 'Shopping',
    icon: Icons.shopping_bag_outlined,
    bgColor: Color(0xFFEFFAE6),
  ),
  entertainment(
    label: 'Entertainment',
    icon: Icons.movie_outlined,
    bgColor: Color(0xFFFFF4E5),
  ),
  health(
    label: 'Health',
    icon: Icons.favorite_outline,
    bgColor: Color(0xFFFFE9EF),
  ),
  other(
    label: 'Other',
    icon: Icons.account_balance_wallet_outlined,
    bgColor: Color(0xFFEFEFEF),
  );

  const ExpenseCategory({
    required this.label,
    required this.icon,
    required this.bgColor,
  });
  final String label;
  final IconData icon;
  final Color bgColor;
}

class AppConfig {
  static const String appName = 'Expense Tracker';
  static const String defaultCurrencySymbol = '₹';

  static List<ExpenseCategory> get categories => ExpenseCategory.values;

  static List<String> get inputCategoryLabels =>
      categories.map((c) => c.label).toList(growable: false);

  static List<String> get defaultCategoryLabels => <String>[
    'All',
    ...inputCategoryLabels,
  ];

  static ExpenseCategory? resolveCategory(String? label) {
    if (label == null) return null;
    final lower = label.toLowerCase().trim();
    for (final c in categories) {
      if (c.label.toLowerCase() == lower) return c;
    }
    return null;
  }
}

class AppUIConstants {
  static const int maxTagsPerExpense = 5;
}
