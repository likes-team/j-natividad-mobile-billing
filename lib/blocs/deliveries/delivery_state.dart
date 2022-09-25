part of 'delivery_cubit.dart';

enum DeliveriesStatus{
  success,
  error,
  loading,
  unknown,
}

class DeliveryState extends Equatable {
  final List<Delivery>? inProgressList;
  final List<Delivery>? pendingList;
  final List<Delivery>? deliveredList;
  final List<FailedDelivery>? failedDeliveriesList;
  final Delivery? selectedDelivery;
  final DeliveriesStatus? deliveriesStatus;
  final String? statusMessage;

  const DeliveryState({
    this.inProgressList,
    this.pendingList,
    this.deliveredList,
    this.failedDeliveriesList,
    this.deliveriesStatus, 
    this.statusMessage, 
    this.selectedDelivery,
  });

  DeliveryState copyWith({
    List<Delivery>? inProgressList,
    List<Delivery>? pendingList,
    List<Delivery>? deliveredList,
    Delivery? selectedDelivery,
    DeliveriesStatus? deliveriesStatus,
    String? messageStatus,
    List<FailedDelivery>? failedDeliveriesList
  }){
    return DeliveryState(
      inProgressList: inProgressList ?? this.inProgressList,
      pendingList: pendingList ?? this.pendingList,
      deliveredList: deliveredList ?? this.deliveredList,
      selectedDelivery: selectedDelivery ?? this.selectedDelivery,
      deliveriesStatus: deliveriesStatus ?? this.deliveriesStatus,
      statusMessage: messageStatus ?? this.statusMessage,
      failedDeliveriesList: failedDeliveriesList ?? this.failedDeliveriesList
    );
  }

  @override
  List<Object?> get props => [
    inProgressList,
    pendingList,
    deliveredList,
    deliveriesStatus, 
    statusMessage, 
    selectedDelivery,
    failedDeliveriesList,
  ];
}
