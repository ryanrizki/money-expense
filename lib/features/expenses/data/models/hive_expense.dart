import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class HiveExpense extends HiveObject {
  HiveExpense({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.categoryIndex,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double amount;

  @HiveField(4)
  int categoryIndex;
}

class HiveExpenseAdapter extends TypeAdapter<HiveExpense> {
  @override
  final int typeId = 1;

  @override
  HiveExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HiveExpense(
      id: fields[0] as String,
      name: fields[1] as String,
      date: fields[2] as DateTime,
      amount: (fields[3] as num).toDouble(),
      categoryIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveExpense obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.categoryIndex);
  }
}
