import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jnb_mobile/blocs/map/delivery_map_cubit.dart';
import 'package:jnb_mobile/models/user_location_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late DeliveryMapCubit _deliveryMapCubit;
  UserLocation? userLocation;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    // Get bloc instances
    _deliveryMapCubit = BlocProvider.of<DeliveryMapCubit>(context);

    // Load initial data
    _deliveryMapCubit.loadDeliveryMarkers();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition);
    GoogleMapController? mapControllers;
    mapControllers
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _onMapCreated(GoogleMapController controller) {
    //To locatePosition
    locatePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<DeliveryMapCubit, DeliveryMapState>(
        builder: (context, state) {
          return GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: _onMapCreated,
            markers: state.deliveryMarkers != null 
            ? state.deliveryMarkers!.toSet()
            : {},
            initialCameraPosition: CameraPosition(
              target: LatLng(14.5032211, 121.0622898),
              zoom: 15,
            ),
          );
        },
      ),
    );
  }
}
