import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddExpenseSheetModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final tagController = TextEditingController();

  final List<String> tags = <String>[];
  DateTime selectedDate = DateTime.now();

  final List<String> categories = const <String>[
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];

  String? selectedCategory;

  void addTag() {
    final raw = tagController.text.trim();
    if (raw.isEmpty) return;
    if (!tags.contains(raw)) {
      tags.add(raw);
      notifyListeners();
    }
    tagController.clear();
  }

  void removeTag(String tag) {
    tags.remove(tag);
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    tagController.dispose();
    super.dispose();
  }
}
