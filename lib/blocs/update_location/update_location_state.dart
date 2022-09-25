part of 'update_location_cubit.dart';


enum UpdateLocationStatus {
  updating,
  success,
  failed,
}

class UpdateLocationState extends Equatable {
  final UpdateLocationStatus? updateLocationStatus;
  final String? statusMessage;

  const UpdateLocationState({
    this.updateLocationStatus,
    this.statusMessage
  });

  UpdateLocationState copyWith({
    UpdateLocationStatus? updateLocationStatus,
    String? statusMessage}
  ){
    return UpdateLocationState(
      updateLocationStatus: updateLocationStatus,
      statusMessage: statusMessage
    );
  }

  @override
  List<Object?> get props => [
    updateLocationStatus,
    statusMessage
  ];
}
