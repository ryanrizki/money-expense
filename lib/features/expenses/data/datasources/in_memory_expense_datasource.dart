import '../../domain/entities/expense.dart';

class InMemoryExpenseDataSource {
  final List<Expense> _items = [];

  Future<List<Expense>> getAll() async {
    // Simulate async
    await Future.delayed(const Duration(milliseconds: 50));
    // Return a copy to avoid external mutation
    return List.unmodifiable(_items);
  }

  Future<void> add(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _items.add(expense);
  }
}
