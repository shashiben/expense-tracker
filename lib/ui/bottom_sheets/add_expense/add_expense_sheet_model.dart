import 'package:flutter/material.dart';
import 'package:expense_tracker/app/app.constants.dart';
import 'package:stacked/stacked.dart';

class AddExpenseSheetModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final tagController = TextEditingController();

  final List<String> tags = <String>[];
  DateTime selectedDate = DateTime.now();

  final List<String> categories = AppConfig.inputCategoryLabels;

  String? selectedCategory;

  void addTag() {
    final raw = tagController.text.trim();
    if (raw.isEmpty) return;
    if (tags.length >= AppUIConstants.maxTagsPerExpense) {
      tagController.clear();
      return;
    }
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

  void initFromExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required List<String> existingTags,
  }) {
    titleController.text = title;
    amountController.text = amount.toString();
    selectedCategory = category;
    selectedDate = date;
    tags
      ..clear()
      ..addAll(existingTags);
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
