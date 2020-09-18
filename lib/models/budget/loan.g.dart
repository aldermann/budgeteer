// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoanAdapter extends TypeAdapter<Loan> {
  @override
  final int typeId = 6;

  @override
  Loan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Loan()
      .._paymentLink = fields[3] as HiveLink<LoanPayment>
      ..name = fields[0] as String
      ..amount = fields[1] as Currency
      ..time = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Loan obj) {
    writer
      ..writeByte(4)
      ..writeByte(3)
      ..write(obj._paymentLink)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoanPaymentAdapter extends TypeAdapter<LoanPayment> {
  @override
  final int typeId = 7;

  @override
  LoanPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoanPayment()
      .._loanLink = fields[3] as HiveLink<Loan>
      ..name = fields[0] as String
      ..amount = fields[1] as Currency
      ..time = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, LoanPayment obj) {
    writer
      ..writeByte(4)
      ..writeByte(3)
      ..write(obj._loanLink)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoanPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
