import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/expense_repository.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc(this._repo) : super(const ExpensesState.initial()) {
    on<ExpensesStarted>(_onStarted);
    on<ExpenseAdded>(_onAdded);
  }

  final ExpenseRepository _repo;

  Future<void> _onStarted(ExpensesStarted event, Emitter<ExpensesState> emit) async {
    emit(state.copyWith(status: ExpensesStatus.loading));
    final items = await _repo.getAll();
    final todayTotal = await _repo.getTodayTotal();
    final monthTotal = await _repo.getMonthTotal(DateTime.now());
    emit(state.copyWith(
      status: ExpensesStatus.ready,
      items: items,
      todayTotal: todayTotal,
      monthTotal: monthTotal,
      categories: _repo.categories(),
    ));
  }

  Future<void> _onAdded(ExpenseAdded event, Emitter<ExpensesState> emit) async {
    await _repo.add(event.expense);
    add(const ExpensesStarted());
  }
}
