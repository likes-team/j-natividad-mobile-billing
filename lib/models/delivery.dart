import 'package:hive/hive.dart';
import 'package:jnb_mobile/models/user_location_model.dart';

part 'delivery.g.dart';

@HiveType(typeId: 0)
class Delivery {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  String? status;

  @HiveField(2)
  final String? subscriberID;

  @HiveField(3)
  final String? subscriberFname;

  @HiveField(4)
  final String? subscriberLname;

  @HiveField(5)
  final String? subscriberAddress;

  @HiveField(6)
  final String? subscriberEmail;

  @HiveField(7)
  final String? deliveryDate;

  @HiveField(8)
  final String? longitude;

  @HiveField(9)
  final String? latitude;

  @HiveField(10)
  final String? areaID;

  @HiveField(11)
  final String? areaName;

  @HiveField(12)
  final String? subAreaID;

  @HiveField(13)
  final String? subAreaName;

  @HiveField(14)
  final String? imagePath;

  @HiveField(15)
  final String? contractNo;

  @HiveField(16)
  final String? remarks;

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
    this.areaID,
    this.areaName,
    this.subAreaID,
    this.subAreaName,
    this.imagePath,
    this.contractNo,
    this.remarks
  });

  factory Delivery.fromJson(json) {
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
      areaID: json['area_id'],
      areaName: json['area_name'],
      subAreaID: json['sub_area_id'],
      subAreaName: json['sub_area_name'],
      imagePath: json['image_path'],
      contractNo: json['contract_no'],
      remarks: json['remarks']
    );
  }

  factory Delivery.updateStatusAndImage({required Delivery delivery, String? newStatus, String? newImagePath}){
    return Delivery(
      id: delivery.id,
      status: newStatus,
      subscriberID: delivery.subscriberID,
      subscriberFname: delivery.subscriberFname,
      subscriberLname: delivery.subscriberLname,
      subscriberAddress: delivery.subscriberAddress,
      subscriberEmail: delivery.subscriberEmail,
      deliveryDate: delivery.deliveryDate,
      latitude: delivery.latitude,
      longitude: delivery.longitude,
      areaID: delivery.areaID,
      areaName: delivery.areaName,
      subAreaID: delivery.subAreaID,
      subAreaName: delivery.subAreaName,
      imagePath: newImagePath ?? delivery.imagePath,
      contractNo: delivery.contractNo,
      remarks: delivery.remarks
    );
  }

  factory Delivery.updateSubscriberLocation({required Delivery delivery, required UserLocation userLocation}){
    return Delivery(
      id: delivery.id,
      status: delivery.status,
      subscriberID: delivery.subscriberID,
      subscriberFname: delivery.subscriberFname,
      subscriberLname: delivery.subscriberLname,
      subscriberAddress: delivery.subscriberAddress,
      subscriberEmail: delivery.subscriberEmail,
      deliveryDate: delivery.deliveryDate,
      latitude: userLocation.latitude.toString(),
      longitude: userLocation.longitude.toString(),
      areaID: delivery.areaID,
      areaName: delivery.areaName,
      subAreaID: delivery.subAreaID,
      subAreaName: delivery.subAreaName,
      imagePath: delivery.imagePath,
      contractNo: delivery.contractNo,
      remarks: delivery.remarks
    );
  }

  factory Delivery.updateRemarks({required Delivery delivery, required String newRemarks}){
    return Delivery(
      id: delivery.id,
      status: delivery.status,
      subscriberID: delivery.subscriberID,
      subscriberFname: delivery.subscriberFname,
      subscriberLname: delivery.subscriberLname,
      subscriberAddress: delivery.subscriberAddress,
      subscriberEmail: delivery.subscriberEmail,
      deliveryDate: delivery.deliveryDate,
      latitude: delivery.latitude,
      longitude: delivery.longitude,
      areaID: delivery.areaID,
      areaName: delivery.areaName,
      subAreaID: delivery.subAreaID,
      subAreaName: delivery.subAreaName,
      imagePath: delivery.imagePath,
      contractNo: delivery.contractNo,
      remarks: newRemarks
    );
  }

  String get fullName {
    return this.subscriberFname! + " " + this.subscriberLname!;
  }

  String? get coordinates {
    if (((this.latitude != null) & (this.latitude != "")) &
        (this.longitude != null) &
        (this.longitude != "")) {
      return this.latitude! + " " + this.longitude!;
    }

    return "";
  }

  String generateImageName (){
    return "${this.subscriberFname}${this.subscriberLname}${DateTime.now().toString().trim()}";
  }
}
