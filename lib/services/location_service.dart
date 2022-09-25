import 'dart:async';
// import 'package:location/location.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // UserLocation _currenLocation;

  // Location location = Location();

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    Geolocator.getPositionStream().listen((position) {
          if (position != null) {
            _locationController.add(UserLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            ));
          }
  });
  }
}
