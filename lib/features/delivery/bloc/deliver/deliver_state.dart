part of 'deliver_cubit.dart';

enum DeliverStatus {
  delivered,
  delivering,
  failed,
  unknown,
  info
}

class DeliverState extends Equatable {
  final DeliverStatus deliverStatus;
  final String statusMessage;

  const DeliverState({
    this.statusMessage, 
    this.deliverStatus,
  });

  DeliverState copyWith({
    String messageStatus,
    DeliverStatus deliverStatus,
  }){
    return DeliverState(
      statusMessage: messageStatus ?? this.statusMessage,
      deliverStatus: deliverStatus ?? this.deliverStatus,
    );
  }

  @override
  List<Object> get props => [
    statusMessage, 
    deliverStatus,
  ];
}
