import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jnb_mobile/services/location_service.dart';
import 'package:meta/meta.dart';
import 'package:jnb_mobile/models/user_location_model.dart';

class LocationCubit extends Cubit<UserLocation?> {
  final LocationService _locationService;

  LocationCubit({required LocationService locationService}) :
  _locationService = locationService,
   super(null);

  StreamSubscription? _locationSubscription;

  void getUserLocation(){
    try{
      _locationSubscription?.cancel();
      _locationSubscription = _locationService.locationStream.listen((userLocation) {
        emit(userLocation);
      });
    } catch (err){

    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
