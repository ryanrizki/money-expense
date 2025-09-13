import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/in_memory_expense_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._ds);
  final InMemoryExpenseDataSource _ds;

  @override
  Future<void> add(Expense expense) => _ds.add(expense);

  @override
  Future<List<Expense>> getAll() => _ds.getAll();

  @override
  Future<List<Expense>> getByDate(DateTime date) async {
    final all = await _ds.getAll();
    return all.where((e) => _isSameDate(e.date, date)).toList();
  }

  @override
  Future<double> getMonthTotal(DateTime month) async {
    final all = await _ds.getAll();
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

  bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}
