// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryAdapter extends TypeAdapter<Delivery> {
  @override
  final int typeId = 0;

  @override
  Delivery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Delivery(
      id: fields[0] as int,
      status: fields[1] as String,
      subscriberID: fields[2] as int,
      subscriberFname: fields[3] as String,
      subscriberLname: fields[4] as String,
      subscriberAddress: fields[5] as String,
      subscriberEmail: fields[6] as String,
      deliveryDate: fields[7] as String,
      latitude: fields[9] as String,
      longitude: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Delivery obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.subscriberID)
      ..writeByte(3)
      ..write(obj.subscriberFname)
      ..writeByte(4)
      ..write(obj.subscriberLname)
      ..writeByte(5)
      ..write(obj.subscriberAddress)
      ..writeByte(6)
      ..write(obj.subscriberEmail)
      ..writeByte(7)
      ..write(obj.deliveryDate)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.latitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
