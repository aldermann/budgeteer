// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseTypeAdapter extends TypeAdapter<ExpenseType> {
  @override
  final int typeId = 1;

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

class IncomeTypeAdapter extends TypeAdapter<IncomeType> {
  @override
  final int typeId = 3;

  @override
  IncomeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IncomeType.Salary;
      case 1:
        return IncomeType.Loan;
      case 2:
        return IncomeType.Misc;
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
      case IncomeType.Loan:
        writer.writeByte(1);
        break;
      case IncomeType.Misc:
        writer.writeByte(2);
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

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      name: fields[0] as String,
      amount: fields[1] as Currency,
      time: fields[2] as DateTime,
      type: fields[3] as ExpenseType,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncomeAdapter extends TypeAdapter<Income> {
  @override
  final int typeId = 2;

  @override
  Income read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Income(
      name: fields[0] as String,
      amount: fields[1] as Currency,
      time: fields[2] as DateTime,
      type: fields[3] as IncomeType,
      saving: fields[4] as Currency,
    );
  }

  @override
  void write(BinaryWriter writer, Income obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.saving);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
