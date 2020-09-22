import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';
import '../models.dart';
import 'budget.dart';

part "expense.g.dart";

class ExpenseType extends BudgetType {
  const ExpenseType(String name, IconData icon) : super(name: name, icon: icon);

  static const ExpenseType Necessity =
      const ExpenseType("Necessity", Icons.fastfood);

  static const ExpenseType SelfImprovement =
      const ExpenseType("Self Improvement", Icons.trending_up);

  static const ExpenseType Entertainment =
      const ExpenseType("Entertainment", Icons.games);

  static List<ExpenseType> values = [Necessity, SelfImprovement, Entertainment];
}

class ExpenseTypeAdapter extends TypeAdapter<ExpenseType> {
  @override
  final int typeId = HiveTypeId.ExpenseType;

  @override
  ExpenseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseType.Necessity;
      case 1:
        return ExpenseType.SelfImprovement;
      case 2:
        return ExpenseType.Entertainment;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseType obj) {
    switch (obj) {
      case ExpenseType.Necessity:
        writer.writeByte(0);
        break;
      case ExpenseType.SelfImprovement:
        writer.writeByte(1);
        break;
      case ExpenseType.Entertainment:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

@HiveType(typeId: HiveTypeId.Expense)
class Expense extends Budget {
  @HiveField(3)
  ExpenseType type;

  Expense({
    String name = "",
    Currency amount = Currency.zero,
    DateTime time,
    this.type = ExpenseType.Necessity,
  }) : super(name: name, amount: amount?.negative, time: time);

  @override
  IconData get icon => type.icon;
}
