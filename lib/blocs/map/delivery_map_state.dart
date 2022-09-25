part of 'delivery_map_cubit.dart';

class DeliveryMapState extends Equatable {
  final List<Marker>? deliveryMarkers;
  final BitmapDescriptor? mapMarker;
  const DeliveryMapState({this.deliveryMarkers, this.mapMarker});

  DeliveryMapState copyWith({
    List<Marker>? deliveryMarkers, 
    BitmapDescriptor? mapMarker
    }){
    return DeliveryMapState(
      deliveryMarkers: deliveryMarkers ?? this.deliveryMarkers,
      mapMarker: mapMarker ?? this.mapMarker
    );
  }

  @override
  List<Object?> get props => [
    deliveryMarkers, 
    mapMarker];
}
