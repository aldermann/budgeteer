part of "hive_link.dart";

class HiveLinkAdapter<T extends HiveObject> extends TypeAdapter<HiveLink<T>> {
  @override
  final int typeId = 8;

  @override
  HiveLink<T> read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLink<T>()
      .._boxName = fields[0] as String
      .._key = fields[1] as dynamic;
  }

  @override
  void write(BinaryWriter writer, HiveLink<T> obj) {
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
