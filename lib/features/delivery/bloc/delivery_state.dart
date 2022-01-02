part of 'delivery_cubit.dart';

enum DeliveriesStatus{
  success,
  error,
  loading,
  unknown,
}

enum DeliverStatus {
  delivered,
  delivering,
  failed,
  unknown,
  info
}

class DeliveryState extends Equatable {
  final List<Delivery> deliveriesList;
  final List<FailedDelivery> failedDeliveriesList;
  final Delivery selectedDelivery;
  final DeliveriesStatus deliveriesStatus;
  final DeliverStatus deliverStatus;
  final String statusMessage;

  const DeliveryState({
    this.deliveriesList, 
    this.failedDeliveriesList,
    this.deliveriesStatus, 
    this.statusMessage, 
    this.selectedDelivery,
    this.deliverStatus,
  });

  DeliveryState copyWith({
    List<Delivery> deliveriesList,
    Delivery selectedDelivery,
    DeliveriesStatus deliveriesStatus,
    String messageStatus,
    DeliverStatus deliverStatus,
    DeliverStatus redeliverStatus,
    List<FailedDelivery> failedDeliveriesList
  }){
    return DeliveryState(
      deliveriesList: deliveriesList ?? this.deliveriesList,
      selectedDelivery: selectedDelivery ?? this.selectedDelivery,
      deliveriesStatus: deliveriesStatus ?? this.deliveriesStatus,
      statusMessage: messageStatus ?? this.statusMessage,
      deliverStatus: deliverStatus ?? this.deliverStatus,
      failedDeliveriesList: failedDeliveriesList ?? this.failedDeliveriesList
    );
  }

  @override
  List<Object> get props => [
    deliveriesList, 
    deliveriesStatus, 
    statusMessage, 
    selectedDelivery,
    deliverStatus,
    failedDeliveriesList,
  ];
}
