import 'package:flutter/material.dart';
import 'package:money_expense/features/expenses/presentation/widgets/category_icon.dart';
import '../../domain/entities/expense.dart';

class AllExpensesPage extends StatelessWidget {
  const AllExpensesPage({super.key, required this.title, required this.items});

  final String title;
  final List<Expense> items;

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => b.id.compareTo(a.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final e = sorted[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade200,
                child: CategoryIcon(category: e.category, size: 16),
              ),
              title: Text(e.name),
              subtitle: Text(_formatDate(e.date)),
              trailing: Text(_formatCurrency(e.amount)),
            ),
          );
        },
      ),
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
  5: 'Jumat',
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
