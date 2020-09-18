import 'dart:ui';

import 'package:budgeteer/models/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';
import 'budget.dart';

part "income.g.dart";

class IncomeType extends BudgetType {
  const IncomeType(String name, IconData icon) : super(name: name, icon: icon);

  static const IncomeType Salary =
      const IncomeType("Salary", Icons.monetization_on);

  static const IncomeType Sale = const IncomeType("Sale", Icons.add);

  static List<IncomeType> values = [Salary, Sale];
}

class IncomeTypeAdapter extends TypeAdapter<IncomeType> {
  @override
  final int typeId = HiveTypeId.IncomeType;

  @override
  IncomeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncomeType.Salary;
      case 1:
        return IncomeType.Sale;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, IncomeType obj) {
    switch (obj) {
      case IncomeType.Salary:
        writer.writeByte(0);
        break;
      case IncomeType.Sale:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

@HiveType(typeId: HiveTypeId.Income)
class Income extends Budget {
  @HiveField(3)
  IncomeType type;

  Income({
    String name = "",
    Currency amount = Currency.zero,
    DateTime time,
    this.type = IncomeType.Salary,
  }) : super(name: name, amount: amount, time: time);

  @override
  IconData get icon => type.icon;
}
