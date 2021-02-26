class Delivery {
  final int id;
  final String status;
  final int subscriberID;
  final String subscriberFname;
  final String subscriberLname;
  final String subscriberAddress;
  final String subscriberEmail;
  final String deliveryDate;
  final String longitude;
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
