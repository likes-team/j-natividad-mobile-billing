// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'areas.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AreaAdapter extends TypeAdapter<Area> {
  @override
  final int typeId = 2;

  @override
  Area read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Area(
      areaID: fields[0] as String?,
      areaName: fields[1] as String?,
      areaDescription: fields[2] as String?,
      subAreas: (fields[3] as List?)?.cast<SubArea>(),
    );
  }

  @override
  void write(BinaryWriter writer, Area obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.areaID)
      ..writeByte(1)
      ..write(obj.areaName)
      ..writeByte(2)
      ..write(obj.areaDescription)
      ..writeByte(3)
      ..write(obj.subAreas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
