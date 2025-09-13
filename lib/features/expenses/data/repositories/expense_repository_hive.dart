import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/hive_expense_datasource.dart';
import '../models/hive_expense.dart';

class ExpenseRepositoryHive implements ExpenseRepository {
  ExpenseRepositoryHive(this._ds);
  final HiveExpenseDataSource _ds;

  @override
  Future<void> add(Expense expense) async {
    final hive = HiveExpense(
      id: expense.id,
      name: expense.name,
      date: expense.date,
      amount: expense.amount,
      categoryIndex: expense.category.index,
    );
    await _ds.add(hive);
  }

  @override
  Future<List<Expense>> getAll() async {
    final items = await _ds.getAll();
    return items
        .map((h) => Expense(
              id: h.id,
              name: h.name,
              date: h.date,
              amount: h.amount,
              category: ExpenseCategory.values[h.categoryIndex],
            ))
        .toList();
  }

  @override
  Future<List<Expense>> getByDate(DateTime date) async {
    final all = await getAll();
    return all.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
  }

  @override
  Future<double> getMonthTotal(DateTime month) async {
    final all = await getAll();
    double total = 0.0;
    for (final e in all) {
      if (e.date.year == month.year && e.date.month == month.month) {
        total += e.amount;
      }
    }
    return total;
  }

  @override
  Future<double> getTodayTotal() async {
    final today = DateTime.now();
    final list = await getByDate(today);
    double total = 0.0;
    for (final e in list) {
      total += e.amount;
    }
    return total;
  }

  @override
  List<ExpenseCategory> categories() => ExpenseCategory.values;
}
