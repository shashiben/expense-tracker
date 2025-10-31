class ExpenseModel {
  final DateTime date;
  final String category;
  final List<String> tags = [];
  final String title;
  final double amount;

  ExpenseModel({
    required this.date,
    required this.category,
    required this.title,
    required this.amount,
  });
}
