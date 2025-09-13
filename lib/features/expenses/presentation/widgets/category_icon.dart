import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.category, this.size = 48});
  final ExpenseCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            category.assetPath,
            errorBuilder: (_, __, ___) {
              return Text(
                category.emojiFallback,
                style: TextStyle(fontSize: size),
              );
            },
          ),
        ),
      ),
    );
  }
}
