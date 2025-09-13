part of 'expenses_bloc.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();
  @override
  List<Object?> get props => [];
}

class ExpensesStarted extends ExpensesEvent {
  const ExpensesStarted();
}

class ExpenseAdded extends ExpensesEvent {
  const ExpenseAdded(this.expense);
  final Expense expense;
  @override
  List<Object?> get props => [expense];
}
