import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/global_variables.dart';
import 'package:jnb_mobile/models/delivery.dart';
import 'package:jnb_mobile/models/failed_delivery.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';

part 'deliver_state.dart';

class DeliverCubit extends Cubit<DeliverState> {
  final DeliveryRepository _deliveryRepository;
  final DeliveriesCubit _deliveryCubit;

  DeliverCubit({required DeliveryRepository deliveryRepository, required DeliveriesCubit deliveryCubit}) : 
    _deliveryRepository = deliveryRepository,
    _deliveryCubit = deliveryCubit,
    super(DeliverState());

  void updateRemarks(String value) {
    final Delivery updatedDeliveryData = Delivery.updateRemarks(
      delivery: _deliveryCubit.state.selectedDelivery!,
      newRemarks: value
    );

    _deliveryCubit.updateDeliveryData(updatedDeliveryData);

    if(_deliveryCubit.state.selectedDelivery!.id == updatedDeliveryData.id){
      _deliveryCubit.getDelivery(updatedDeliveryData.id);
    }
  }

  void deliver(Delivery delivery, File? deliveryPhoto, UserLocation? userLocation) async {
    if(delivery.status != "IN-PROGRESS"){
      return;
    }

    if(deliveryPhoto == null){
      emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: ""));
      emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: "Take a picture first to proceed"));
      return;
    }

    emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: "Delivering..."));
    
    File deliveryPhotoCopy;

    try{
      // Save photo
      final imageName = delivery.generateImageName();
      deliveryPhotoCopy = await deliveryPhoto.copy("${globalAppImagesDirectory.path}/$imageName.png");
    } catch (err){
        emit(state.copyWith(
          deliverStatus: DeliverStatus.failed, 
          messageStatus: "Failed to save photo, please try again."
        ));
        return;
    }

    final Delivery updatedDeliveryData = Delivery.updateStatusAndImage(
      delivery: delivery, 
      newStatus: "DELIVERING",
      newImagePath: deliveryPhotoCopy.path
    );

    _deliveryCubit.updateDeliveryData(updatedDeliveryData);

    if(_deliveryCubit.state.selectedDelivery!.id == updatedDeliveryData.id){
      _deliveryCubit.getDelivery(updatedDeliveryData.id);
    }

    // try {
    final String imageName = deliveryPhoto.path.split('/').last;
    _addFailedDelivery(
      delivery: delivery,
      messengerID: "", // TODO
      dateMobileDelivery: DateTime.now(),
      imagePath: deliveryPhotoCopy.path,
      latitude: userLocation!.latitude.toString(),
      longitude: userLocation.longitude.toString(),
      accuracy: userLocation.accuracy.toString(),
      imageName: imageName,
    );  

    emit(state.copyWith(
      deliverStatus: DeliverStatus.delivered,
      messageStatus: "Saved Successfully!"
    ));
  }

  void _addFailedDelivery({
    required Delivery delivery,
    String? messengerID,
    DateTime? dateMobileDelivery,
    String? imagePath,
    String? latitude,
    String? longitude,
    String? accuracy,
    String? imageName,
  }) {
    final Box<FailedDelivery> hiveBox = Hive.box(globalFailedDeliveriesBoxName);

    final FailedDelivery newFailedDelivery = FailedDelivery(
      id: delivery.id,
      messengerID: messengerID,
      subscriberID: delivery.subscriberID,
      dateMobileDelivery: dateMobileDelivery,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      imagePath: imagePath,
      fileName: imageName,
      status: "FAILED",
      subscriberFname: delivery.subscriberFname,
      subscriberLname: delivery.subscriberLname,
      subscriberAddress: delivery.subscriberAddress,
      subscriberEmail: delivery.subscriberEmail,
      deliveryDate: delivery.deliveryDate,
      areaID: delivery.areaID,
      areaName: delivery.areaName,
      subAreaID: delivery.subAreaID,
      subAreaName: delivery.subAreaName,
      remarks: delivery.remarks
    );
    hiveBox.put(newFailedDelivery.id, newFailedDelivery);
  }
}
