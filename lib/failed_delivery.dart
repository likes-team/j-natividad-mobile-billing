import 'dart:io';
import 'package:hive/hive.dart';

part 'failed_delivery.g.dart';

@HiveType(typeId: 1)
class FailedDelivery {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int messengerID;

  @HiveField(2)
  final int subscriberID;

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
  });
}
