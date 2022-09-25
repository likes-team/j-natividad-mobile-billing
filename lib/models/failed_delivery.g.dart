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
      id: fields[0] as String?,
      messengerID: fields[1] as String?,
      subscriberID: fields[2] as String?,
      dateMobileDelivery: fields[3] as DateTime?,
      latitude: fields[4] as String?,
      longitude: fields[5] as String?,
      accuracy: fields[6] as String?,
      imagePath: fields[7] as String?,
      fileName: fields[8] as String?,
      status: fields[9] as String?,
      subscriberFname: fields[10] as String?,
      subscriberLname: fields[11] as String?,
      subscriberAddress: fields[12] as String?,
      subscriberEmail: fields[13] as String?,
      deliveryDate: fields[14] as String?,
      areaID: fields[15] as String?,
      areaName: fields[16] as String?,
      subAreaID: fields[17] as String?,
      subAreaName: fields[18] as String?,
      contractNo: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FailedDelivery obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.fileName)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.subscriberFname)
      ..writeByte(11)
      ..write(obj.subscriberLname)
      ..writeByte(12)
      ..write(obj.subscriberAddress)
      ..writeByte(13)
      ..write(obj.subscriberEmail)
      ..writeByte(14)
      ..write(obj.deliveryDate)
      ..writeByte(15)
      ..write(obj.areaID)
      ..writeByte(16)
      ..write(obj.areaName)
      ..writeByte(17)
      ..write(obj.subAreaID)
      ..writeByte(18)
      ..write(obj.subAreaName)
      ..writeByte(19)
      ..write(obj.contractNo);
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
