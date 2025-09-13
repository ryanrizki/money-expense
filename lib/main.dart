import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/expenses/data/datasources/hive_expense_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_hive.dart';
import 'features/expenses/presentation/bloc/expenses_bloc.dart';
import 'features/expenses/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ds = await HiveExpenseDataSource.create();
  final repo = ExpenseRepositoryHive(ds);
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repo});

  final ExpenseRepositoryHive repo;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExpensesBloc(repo)..add(const ExpensesStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Money Expense',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
