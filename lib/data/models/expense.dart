import 'package:json_annotation/json_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ExpenseModel {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final List<String> tags;

  const ExpenseModel({
    required this.date,
    required this.amount,
    required this.category,
    required this.title,
    this.tags = const <String>[],
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
