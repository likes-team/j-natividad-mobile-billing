// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_delivery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FailedDeliveryAdapter extends TypeAdapter<FailedDelivery> {
  @override
  final int typeId = 1;

  @override
  FailedDelivery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FailedDelivery(
      id: fields[0] as String,
      messengerID: fields[1] as String,
      subscriberID: fields[2] as String,
      dateMobileDelivery: fields[3] as DateTime,
      latitude: fields[4] as String,
      longitude: fields[5] as String,
      accuracy: fields[6] as String,
      imagePath: fields[7] as String,
      fileName: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FailedDelivery obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.messengerID)
      ..writeByte(2)
      ..write(obj.subscriberID)
      ..writeByte(3)
      ..write(obj.dateMobileDelivery)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.accuracy)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.fileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedDeliveryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
