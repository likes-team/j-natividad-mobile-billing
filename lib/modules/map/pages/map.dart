import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> _markers = {};
  BitmapDescriptor mapMarker;
  UserLocation userLocation;
  Position currentPosition;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition);
    GoogleMapController mapControllers;
    mapControllers
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/image/marker.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    //To locatePosition
    locatePosition();

    setState(() {
      List<Delivery> subscribers = Provider.of<DeliveriesProvider>(
        context,
        listen: false,
      ).deliveriesList;

      for (var i = 0; i < subscribers.length; i++) {
        if (subscribers[i].latitude != null &&
            subscribers[i].longitude != null) {
          _markers.add(Marker(
            markerId: MarkerId(subscribers[i].fullName),
            position: LatLng(
              double.parse(subscribers[i].latitude),
              double.parse(subscribers[i].longitude),
            ),
            infoWindow: InfoWindow(
                title: subscribers[i].fullName, snippet: subscribers[i].status),
            icon: mapMarker,
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if enabled Location
    userLocation = Provider.of<UserLocation>(context);

    return Container(
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(14.5032211, 121.0622898),
          zoom: 15,
        ),
      ),
    );
  }
}
