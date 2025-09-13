import '../entities/expense.dart';
import '../entities/category.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAll();
  Future<void> add(Expense expense);
  Future<List<Expense>> getByDate(DateTime date);
  Future<double> getTodayTotal();
  Future<double> getMonthTotal(DateTime month);
  List<ExpenseCategory> categories();
}
