part of 'expenses_bloc.dart';

enum ExpensesStatus { initial, loading, ready, error }

class ExpensesState extends Equatable {
  const ExpensesState({
    required this.status,
    required this.items,
    required this.todayTotal,
    required this.monthTotal,
    required this.categories,
  });

  const ExpensesState.initial()
      : status = ExpensesStatus.initial,
        items = const [],
        todayTotal = 0,
        monthTotal = 0,
        categories = const [];

  final ExpensesStatus status;
  final List<Expense> items;
  final double todayTotal;
  final double monthTotal;
  final List<ExpenseCategory> categories;

  ExpensesState copyWith({
    ExpensesStatus? status,
    List<Expense>? items,
    double? todayTotal,
    double? monthTotal,
    List<ExpenseCategory>? categories,
  }) =>
      ExpensesState(
        status: status ?? this.status,
        items: items ?? this.items,
        todayTotal: todayTotal ?? this.todayTotal,
        monthTotal: monthTotal ?? this.monthTotal,
        categories: categories ?? this.categories,
      );

  @override
  List<Object?> get props => [status, items, todayTotal, monthTotal, categories];
}
