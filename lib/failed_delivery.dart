import 'package:hive/hive.dart';

part 'failed_delivery.g.dart';

@HiveType(typeId: 1)
class FailedDelivery {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String messengerID;

  @HiveField(2)
  final String subscriberID;

  @HiveField(3)
  final DateTime dateMobileDelivery;

  @HiveField(4)
  final String latitude;

  @HiveField(5)
  final String longitude;

  @HiveField(6)
  final String accuracy;

  @HiveField(7)
  final String imagePath;

  @HiveField(8)
  final String fileName;

  @HiveField(9)
  String status;

  @HiveField(10)
  final String subscriberFname;

  @HiveField(11)
  final String subscriberLname;

  @HiveField(12)
  final String subscriberAddress;

  @HiveField(13)
  final String subscriberEmail;

  @HiveField(14)
  final String deliveryDate;

  @HiveField(15)
  final String areaID;

  @HiveField(16)
  final String areaName;

  @HiveField(17)
  final String subAreaID;

  @HiveField(18)
  final String subAreaName;

  @HiveField(19)
  final String contractNo;

  FailedDelivery({
    this.id,
    this.messengerID,
    this.subscriberID,
    this.dateMobileDelivery,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.imagePath,
    this.fileName,
    this.status,
    this.subscriberFname,
    this.subscriberLname,
    this.subscriberAddress,
    this.subscriberEmail,
    this.deliveryDate,
    this.areaID,
    this.areaName,
    this.subAreaID,
    this.subAreaName,
    this.contractNo
  });

  String get fullName {
    return this.subscriberFname + " " + this.subscriberLname;
  }

  String get coordinates {
    if (((this.latitude != null) & (this.latitude != "")) &
        (this.longitude != null) &
        (this.longitude != "")) {
      return this.latitude + " " + this.longitude;
    }

    return null;
  }
}
