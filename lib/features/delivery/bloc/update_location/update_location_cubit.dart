import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:meta/meta.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';

part 'update_location_state.dart';

class UpdateLocationCubit extends Cubit<UpdateLocationState> {
  final DeliveryRepository _deliveryRepository;
  final DeliveryCubit _deliveryCubit;

  UpdateLocationCubit({@required DeliveryRepository deliveryRepository, @required DeliveryCubit deliveryCubit}) : 
    _deliveryRepository = deliveryRepository,
    _deliveryCubit = deliveryCubit,
    super(UpdateLocationState());


  Future<void> updateLocation({Delivery delivery, UserLocation userLocation}) async {
    emit(state.copyWith(
      updateLocationStatus: UpdateLocationStatus.updating,
      statusMessage: "Updating Location, please wait..."));

    try {
      await _deliveryRepository.updateLocation(
        subscriberId: delivery.subscriberID, 
        userLocation: userLocation
        ).then((response) {

        Delivery deliveryUpdateObject = Delivery.updateSubscriberLocation(
          delivery: delivery,
          userLocation: userLocation
        );

        _deliveryCubit.updateDeliveryData(deliveryUpdateObject);
        emit(state.copyWith(
          updateLocationStatus: UpdateLocationStatus.success, 
          statusMessage: "Location Updated Successfully"
        ));

        if(_deliveryCubit.state.selectedDelivery.id == deliveryUpdateObject.id){
          _deliveryCubit.updateSelectedDelivery(deliveryUpdateObject);
        }
      }).catchError((onError){
        emit(state.copyWith(
          updateLocationStatus: UpdateLocationStatus.failed, 
          statusMessage: "Updating Failed, please contact system administrator or try again"
        ));
      });
    } catch (_) {
      emit(state.copyWith(
        updateLocationStatus: UpdateLocationStatus.failed, 
        statusMessage: "Updating Failed, please contact system administrator or try again"
      ));
    }
  }
}
