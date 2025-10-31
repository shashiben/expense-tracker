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

  static const double spacingXXS = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingSM = 6.0;
  static const double spacingMD = 8.0;
  static const double spacingLG = 12.0;
  static const double spacingXL = 16.0;
  static const double spacingXXL = 24.0;

  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 24.0;

  static const double radiusSM = 6.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 10.0;
  static const double radiusXL = 12.0;
  static const double radiusPill = 999.0;
  static const double radiusCircle = 22.0;

  static const double iconSizeXS = 14.0;
  static const double iconSizeSM = 18.0;
  static const double iconSizeMD = 22.0;
  static const double iconSizeLG = 24.0;
}
