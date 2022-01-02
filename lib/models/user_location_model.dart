class UserLocation {
  final double latitude;
  final double longitude;
  final double accuracy;

  UserLocation({this.latitude, this.longitude, this.accuracy});

  String get fullLocation {
    return this.latitude.toString() + " - " + this.longitude.toString();
  }
}
