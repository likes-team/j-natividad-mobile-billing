import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';

part 'delivery_map_state.dart';

class DeliveryMapCubit extends Cubit<DeliveryMapState> {
  final DeliveryCubit _deliveryCubit;

  DeliveryMapCubit({DeliveryCubit deliveryCubit}) :
    _deliveryCubit = deliveryCubit,
   super(DeliveryMapState());

  Future<void> setCustomMarker() async {
    final mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/image/marker.png');
    emit(state.copyWith(mapMarker: mapMarker));
  }

  void loadDeliveryMarkers() async{
    await setCustomMarker();

    final List<Delivery> deliveries = _deliveryCubit.state.inProgressList;
    List<Marker> markersList = [];
    print(deliveries);

    for (var i = 0; i < deliveries.length; i++) {
      if ((deliveries[i].latitude != null || deliveries[i].latitude != '') &&
          (deliveries[i].longitude != null || deliveries[i].longitude != '')) {
        final marker = Marker(
          markerId: MarkerId(deliveries[i].fullName),
          position: LatLng(
            double.parse(deliveries[i].latitude),
            double.parse(deliveries[i].longitude),
          ),
          infoWindow: InfoWindow(
              title: deliveries[i].fullName, snippet: deliveries[i].status),
          icon: state.mapMarker,
        );
        markersList.add(marker);
      }
    }

    emit(state.copyWith(deliveryMarkers: markersList));
  }
}
