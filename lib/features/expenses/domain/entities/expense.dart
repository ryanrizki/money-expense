import 'category.dart';

class Expense {
  final String id;
  final String name;
  final DateTime date;
  final double amount;
  final ExpenseCategory category;

  Expense({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.category,
  });
}
