import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final double amount;
  AddExpense(this.amount);
}

// States
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseUpdated extends ExpenseState {
  final double total;
  ExpenseUpdated(this.total);
}

// Bloc
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  double _total = 0;

  ExpenseBloc() : super(ExpenseInitial()) {
    on<AddExpense>((event, emit) {
      _total += event.amount;
      emit(ExpenseUpdated(_total));
    });
  }
}
