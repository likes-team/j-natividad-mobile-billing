part of 'failed_deliver_cubit.dart';

enum RedeliverStatus {
  delivered,
  delivering,
  failed,
  unknown,
  info
}

class FailedDeliverState extends Equatable {
  final RedeliverStatus redeliverStatus;
  final String statusMessage;

  const FailedDeliverState({this.redeliverStatus, this.statusMessage});

  FailedDeliverState copyWith({
    String statusMessage,
    RedeliverStatus redeliverStatus,
  }){
    return FailedDeliverState(
      statusMessage: statusMessage ?? this.statusMessage,
      redeliverStatus: redeliverStatus ?? this.redeliverStatus,
    );
  }

  @override
  List<Object> get props => [
    redeliverStatus,
    statusMessage
  ];
}
