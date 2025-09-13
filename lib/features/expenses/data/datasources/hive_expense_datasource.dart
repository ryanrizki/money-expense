import 'package:hive_flutter/hive_flutter.dart';

import '../models/hive_expense.dart';

class HiveExpenseDataSource {
  HiveExpenseDataSource(this._box);
  final Box<HiveExpense> _box;

  static const String boxName = 'expenses_box';

  static Future<HiveExpenseDataSource> create() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HiveExpenseAdapter());
    }
    final box = await Hive.openBox<HiveExpense>(boxName);
    return HiveExpenseDataSource(box);
  }

  Future<List<HiveExpense>> getAll() async {
    return _box.values.toList(growable: false);
    
  }

  Future<void> add(HiveExpense item) async {
    await _box.put(item.id, item);
  }
}
