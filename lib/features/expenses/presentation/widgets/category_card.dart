import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import 'category_icon.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.amount});
  final ExpenseCategory category;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: CategoryIcon(category: category, size: 24),
          ),
          const SizedBox(height: 12),
          Text(category.label, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(amount),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double v) {
  final s = v.round().toString();
  final withDots =
      s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  return 'Rp. $withDots';
}
