import 'package:flutter/material.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  final String token =
      'pk.eyJ1Ijoic2t5amF5YTAwOCIsImEiOiJja204dGFzZHMwemV1MnptenRnNjZibDd2In0.IkyuG4a4Oc2cZ-waL9QVjA';
  final String style = 'mapbox://styles/skyjaya008/ckm8thh0j75c517r29qzqjon9';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
          accessToken: widget.token,
          styleString: widget.style,
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: () => addCircle(),
          initialCameraPosition: CameraPosition(
            target: LatLng(14.232940, 121.090019),
            zoom: 10,
          )),
    );
  }

  void addCircle() {
    List<Delivery> subscribers = Provider.of<DeliveriesProvider>(
      context,
      listen: false,
    ).deliveriesList;

    for (var i = 0; i < subscribers.length; i++) {
      if (subscribers[i].latitude != null && subscribers[i].longitude != null) {
        mapController.addSymbol(SymbolOptions(
            geometry: LatLng(double.parse(subscribers[i].latitude),
                double.parse(subscribers[i].longitude)),
            iconImage: "assets/image/marker.png"));
      }
    }
  }
}
