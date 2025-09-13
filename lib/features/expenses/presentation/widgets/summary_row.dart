import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.today, required this.month, required this.formatCurrency});
  final double today;
  final double month;
  final String Function(double) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Pengeluaranmu hari ini',
            amount: today,
            color: const Color(0xFF0A97B0),
            formatCurrency: formatCurrency,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Pengeluaranmu bulan ini',
            amount: month,
            color: const Color(0xFF46B5A7),
            formatCurrency: formatCurrency,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.amount, required this.color, required this.formatCurrency});
  final String title;
  final double amount;
  final Color color;
  final String Function(double) formatCurrency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        Text(
          formatCurrency(amount),
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
