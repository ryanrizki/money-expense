import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../bloc/expenses_bloc.dart';
import 'new_expense_page.dart';
import 'all_expenses_page.dart';
import '../widgets/summary_row.dart';
import '../widgets/category_card.dart';
import '../widgets/category_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ExpensesBloc, ExpensesState>(
          builder: (context, state) {
            if (state.status == ExpensesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final totals = _categoryTotals(state.items);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Halo, User!',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 8),
                const Text("Jangan lupa catat keuanganmu setiap hari!",
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                const SizedBox(height: 16),
                SummaryRow(
                  today: state.todayTotal,
                  month: state.monthTotal,
                  formatCurrency: _formatCurrency,
                ),
                const SizedBox(height: 16),
                const Text('Pengeluaran berdasarkan kategori',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final c = state.categories[index];
                      final amount = totals[c] ?? 0.0;
                      return CategoryCard(category: c, amount: amount);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Hari ini',
                  allItems: state.items
                      .where((e) => _isSameDate(e.date, DateTime.now()))
                      .toList(),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  title: 'Kemarin',
                  allItems: state.items
                      .where((e) => _isSameDate(e.date,
                          DateTime.now().subtract(const Duration(days: 1))))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = context.read<ExpensesBloc>();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const NewExpensePage()))
              .then((_) {
            // refresh when returned
            bloc.add(const ExpensesStarted());
          });
        },
        backgroundColor: const Color(0xFF0A97B0),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Widget> _buildList(Iterable<Expense> items) {
    return items
        .map((e) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  child: CategoryIcon(category: e.category, size: 24),
                ),
                title: Text(e.name),
                subtitle: Text(_formatDate(e.date)),
                trailing: Text(_formatCurrency(e.amount)),
              ),
            ))
        .toList();
  }

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // Computes total amount per category used by the horizontal list
  Map<ExpenseCategory, double> _categoryTotals(List<Expense> items) {
    final map = <ExpenseCategory, double>{};
    for (final e in items) {
      map[e.category] = (map[e.category] ?? 0.0) + e.amount;
    }
    return map;
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Expense> allItems}) {
    final sorted = [...allItems]..sort((a, b) => b.id.compareTo(a.id));
    final limited = sorted.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (allItems.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllExpensesPage(
                        title: title,
                        items: allItems,
                      ),
                    ),
                  );
                },
                child: const Text('Lihat semua'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (limited.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Belum ada pengeluaran',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          )
        else
          ..._buildList(limited),
      ],
    );
  }
}

String _formatCurrency(double v) => 'Rp. ${_thousands(v.round())}';

String _thousands(int value) {
  final s = value.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
}

String _formatDate(DateTime d) {
  return '${_weekday[d.weekday]}, ${d.day} ${_month[d.month]} ${d.year}';
}

const _weekday = {
  1: 'Senin',
  2: 'Selasa',
  3: 'Rabu',
  4: 'Kamis',
  5: "Jumat",
  6: 'Sabtu',
  7: 'Minggu',
};

const _month = {
  1: 'Januari',
  2: 'Februari',
  3: 'Maret',
  4: 'April',
  5: 'Mei',
  6: 'Juni',
  7: 'Juli',
  8: 'Agustus',
  9: 'September',
  10: 'Oktober',
  11: 'November',
  12: 'Desember',
};
