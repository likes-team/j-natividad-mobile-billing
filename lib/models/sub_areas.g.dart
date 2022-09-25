// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_areas.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubAreaAdapter extends TypeAdapter<SubArea> {
  @override
  final int typeId = 3;

  @override
  SubArea read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubArea(
      subAreaID: fields[0] as String?,
      subAreaName: fields[1] as String?,
      subAreaDescription: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubArea obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subAreaID)
      ..writeByte(1)
      ..write(obj.subAreaName)
      ..writeByte(2)
      ..write(obj.subAreaDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubAreaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
