import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/globals.dart';
import 'package:meta/meta.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';

part 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  final DeliveryRepository _deliveryRepository;

  DeliveryCubit({@required DeliveryRepository deliveryRepository}) : 
    _deliveryRepository = deliveryRepository,
    super(DeliveryState());

  final String _deliveriesBoxName = 'deliveries';


  void fetchDeliveries() async {
    emit(state.copyWith(deliveriesStatus: DeliveriesStatus.loading, messageStatus: ""));

    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    final Box<FailedDelivery> failedDeliveriesHiveBox = Hive.box(AppGlobals.failedDeliveriesBoxName);

    try{
      final List<Delivery> deliveries = await _deliveryRepository.fetchDeliveries();
      // List<String> failedDeliveriesIds =
      //     await failedDeliveriesService.getFailedDeliveriesIds();
      // if (failedDeliveriesIds.length == 0) {
      //   for (var delivery in deliveries) {
      //     box.put(delivery.id, delivery);
      //   }

      //   return;
      // }

      for (var delivery in deliveries) {
        Delivery hiveDeliveryData = hiveBox.get(delivery.id);
        if(hiveDeliveryData == null){
          hiveBox.put(delivery.id, delivery);
          continue;
        }
        
        if(hiveDeliveryData.status == "DELIVERING"){
          FailedDelivery failedDeliveryData = failedDeliveriesHiveBox.get(delivery.id);

          if(failedDeliveryData == null){
            hiveBox.put(delivery.id, delivery);
            continue;
          }
        }

        if(delivery.status != "IN-PROGRESS"){
          hiveBox.put(delivery.id, delivery);
        }
      }
    } catch(err){
      emit(state.copyWith(
        deliveriesStatus: DeliveriesStatus.error,
        messageStatus: err.toString(),
        deliveriesList: hiveBox.values.toList(),
      ));
      return;
    }

    emit(state.copyWith(
      deliveriesStatus: DeliveriesStatus.success,
      messageStatus: "Success",
      deliveriesList: hiveBox.values.toList()
    ));
  }

  void getDelivery(String id) {
    final Box<Delivery> box = Hive.box(_deliveriesBoxName);
    emit(state.copyWith(
      selectedDelivery: box.get(id),
      deliverStatus: DeliverStatus.unknown,
      messageStatus: "",
    ));
  }


  void deliver(Delivery delivery, File deliveryPhoto, UserLocation userLocation) async {
    if(delivery.status != "IN-PROGRESS"){
      return;
    }

    if(deliveryPhoto == null){
      emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: ""));
      emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: "Take a picture first to proceed"));
      return;
    }

    // if(userLocation != "IN-PROGRESS"){
    //   return;
    // }

    emit(state.copyWith(deliverStatus: DeliverStatus.delivering, messageStatus: "Delivering..."));

    final Delivery updatedDeliveryData = Delivery.updateStatusAndImage(
      delivery: delivery, 
      newStatus: "DELIVERING"
    );

    updateDeliveryData(updatedDeliveryData);

    emit(state.copyWith(selectedDelivery: updatedDeliveryData));

    try {
      _deliveryRepository.deliver(
        delivery:delivery, image: deliveryPhoto, 
        userLocation: userLocation
      ).then((response) {
        print(response);
        Delivery deliveryUpdateObject = Delivery.updateStatusAndImage(
          delivery: delivery,
          newStatus: response.data['data']['status'],
          newImagePath: response.data['data']['image_path']
        );
        updateDeliveryData(deliveryUpdateObject);
        emit(state.copyWith(
          deliverStatus: DeliverStatus.delivered, 
          messageStatus: "Delivered Successfully"
        ));

        if(state.selectedDelivery.id == deliveryUpdateObject.id){
          emit(state.copyWith(
            selectedDelivery: deliveryUpdateObject, 
          ));
        }
      }).catchError((onError){
        emit(state.copyWith(
          deliverStatus: DeliverStatus.failed, 
          messageStatus: "Delivering Failed, resend when internet is available."
        ));

        final String imageName = deliveryPhoto.path.split('/').last;
        _addFailedDelivery(
          delivery: delivery,
          messengerID: "", // TODO
          dateMobileDelivery: DateTime.now(),
          imagePath: deliveryPhoto.path,
          latitude: userLocation.latitude.toString(),
          longitude: userLocation.longitude.toString(),
          accuracy: userLocation.accuracy.toString(),
          imageName: imageName,
        );      
      });
    } catch (_) {
      emit(state.copyWith(
        deliverStatus: DeliverStatus.failed, 
        messageStatus: "Delivering Failed, resend when internet is available."
      ));

      final String imageName = deliveryPhoto.path.split('/').last;
      _addFailedDelivery(
        delivery: delivery,
        messengerID: "", // TODO
        dateMobileDelivery: DateTime.now(),
        imagePath: deliveryPhoto.path,
        latitude: userLocation.latitude.toString(),
        longitude: userLocation.longitude.toString(),
        accuracy: userLocation.accuracy.toString(),
        imageName: imageName,
      );
    }
  }


  // void search(String query){
  //   if(query == ""){
      
  //   }
    

  //   state.deliveriesList.forEach((item) {
  //     print(item.subscriberLname);
  //     if (item.subscriberLname.contains(searchValue)) {
  //       searchedDeliveriesList.add(item);
  //     }
  //   });
  // }

  void fetchDeliveriesActivity() async{
    final Box<FailedDelivery> hiveBox = Hive.box(AppGlobals.failedDeliveriesBoxName);
    final deliveringList = hiveBox.values.toList();
    emit(state.copyWith(failedDeliveriesList: deliveringList));
  }

  void updateSelectedDelivery(Delivery delivery){
    emit(state.copyWith(selectedDelivery: delivery));
  }

  void _addFailedDelivery({
    Delivery delivery,
    String messengerID,
    DateTime dateMobileDelivery,
    String imagePath,
    String latitude,
    String longitude,
    String accuracy,
    String imageName,
  }) {
    final Box<FailedDelivery> hiveBox = Hive.box(AppGlobals.failedDeliveriesBoxName);

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
    );
    hiveBox.put(newFailedDelivery.id, newFailedDelivery);
  }


  void updateDeliveryData(Delivery delivery){
    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    hiveBox.put(delivery.id, delivery);
    emit(state.copyWith(deliveriesList: hiveBox.values.toList()));
  }

  void updateFailedDeliveryData({String deliveryId, String newStatus, String newImagePath}){
    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    
    final Delivery deliveryToUpdate = hiveBox.get(deliveryId);
    final Delivery deliveryUpdated = Delivery.updateStatusAndImage(
      delivery: deliveryToUpdate,
      newStatus: newStatus,
      newImagePath: newImagePath
    );

    hiveBox.put(deliveryUpdated.id, deliveryUpdated);
    emit(state.copyWith(deliveriesList: hiveBox.values.toList()));
  }
}
