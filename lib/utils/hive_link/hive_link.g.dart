// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_link.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLinkAdapter extends TypeAdapter<HiveLink> {
  @override
  final int typeId = 0;

  @override
  HiveLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLink()
      .._boxName = fields[0] as String
      .._key = fields[1] as dynamic;
  }

  @override
  void write(BinaryWriter writer, HiveLink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._boxName)
      ..writeByte(1)
      ..write(obj._key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
