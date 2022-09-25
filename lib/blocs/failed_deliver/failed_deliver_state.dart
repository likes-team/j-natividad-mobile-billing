part of 'failed_deliver_cubit.dart';

enum RedeliverStatus {
  delivered,
  delivering,
  failed,
  unknown,
  info
}

class FailedDeliverState extends Equatable {
  final RedeliverStatus? redeliverStatus;
  final String? statusMessage;
  final int? forUploadCount;
  final int? uploadedCount;

  const FailedDeliverState({this.redeliverStatus, this.statusMessage, this.forUploadCount, this.uploadedCount});

  FailedDeliverState copyWith({
    String? statusMessage,
    RedeliverStatus? redeliverStatus,
    int? forUploadCount,
    int? uploadedCount,
  }){
    return FailedDeliverState(
      statusMessage: statusMessage ?? this.statusMessage,
      redeliverStatus: redeliverStatus ?? this.redeliverStatus,
      forUploadCount: forUploadCount ?? this.forUploadCount,
      uploadedCount: uploadedCount ?? this.uploadedCount  
    );
  }

  @override
  List<Object?> get props => [
    redeliverStatus,
    statusMessage,
    forUploadCount,
    uploadedCount
  ];
}
