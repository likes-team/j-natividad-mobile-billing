import 'package:hive/hive.dart';

part 'delivery.g.dart';

@HiveType(typeId: 0)
class Delivery {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String status;
  @HiveField(2)
  final int subscriberID;
  @HiveField(3)
  final String subscriberFname;
  @HiveField(4)
  final String subscriberLname;
  @HiveField(5)
  final String subscriberAddress;
  @HiveField(6)
  final String subscriberEmail;
  @HiveField(7)
  final String deliveryDate;
  @HiveField(8)
  final String longitude;
  @HiveField(9)
  final String latitude;

  Delivery({
    this.id,
    this.status,
    this.subscriberID,
    this.subscriberFname,
    this.subscriberLname,
    this.subscriberAddress,
    this.subscriberEmail,
    this.deliveryDate,
    this.latitude,
    this.longitude,
  });

  factory Delivery.fromJson(json) {
    if (json != null) {
      return Delivery(
        id: json['id'],
        status: json['status'],
        subscriberID: json['subscriber_id'],
        subscriberFname: json['subscriber_fname'],
        subscriberLname: json['subscriber_lname'],
        subscriberAddress: json['subscriber_address'],
        subscriberEmail: json['subscriber_email'],
        deliveryDate: json['delivery_date'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
    }
    return null;
  }

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