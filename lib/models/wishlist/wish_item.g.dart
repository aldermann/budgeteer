// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishItemAdapter extends TypeAdapter<WishItem> {
  @override
  final int typeId = 9;

  @override
  WishItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishItem(
      name: fields[0] as String,
      price: fields[3] as Currency,
      considerationEnd: fields[4] as DateTime,
      type: fields[5] as ExpenseType,
    )..description = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, WishItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.considerationEnd)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
