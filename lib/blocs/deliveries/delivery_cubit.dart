import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/global_variables.dart';
import 'package:jnb_mobile/models/delivery.dart';
import 'package:jnb_mobile/models/failed_delivery.dart';
import 'package:meta/meta.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';

part 'delivery_state.dart';

class DeliveriesCubit extends Cubit<DeliveryState> {
  final DeliveryRepository _deliveryRepository;

  DeliveriesCubit({required DeliveryRepository deliveryRepository}) : 
    _deliveryRepository = deliveryRepository,
    super(DeliveryState());

  final String _deliveriesBoxName = 'deliveries';


  void fetchDeliveries() async {
    emit(state.copyWith(deliveriesStatus: DeliveriesStatus.loading, messageStatus: ""));

    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    final Box<FailedDelivery> failedDeliveriesHiveBox = Hive.box(globalFailedDeliveriesBoxName);

    List<Delivery> inProgressList = [];
    List<Delivery> pendingList = [];
    List<Delivery> deliveredList = [];

    try{
      final List deliveries = await _deliveryRepository.fetchDeliveries();
      // List<String> failedDeliveriesIds =
      //     await failedDeliveriesService.getFailedDeliveriesIds();
      // if (failedDeliveriesIds.length == 0) {
      //   for (var delivery in deliveries) {
      //     box.put(delivery.id, delivery);
      //   }

      //   return;
      // }
      List<String?> deliveryIds = [];

      for (var delivery in deliveries) {
        deliveryIds.add(delivery.id);

        Delivery? hiveDeliveryData = hiveBox.get(delivery.id);

        if(hiveDeliveryData == null){
          hiveBox.put(delivery.id, delivery);
          continue;
        }
        
        if(hiveDeliveryData.status == "DELIVERING"){
          FailedDelivery? failedDeliveryData = failedDeliveriesHiveBox.get(delivery.id);

          if(failedDeliveryData == null){
            hiveBox.put(delivery.id, delivery);
            continue;
          }
        }

        if(delivery.status != "IN-PROGRESS"){
          hiveBox.put(delivery.id, delivery);
        }
      }

      for(var storedDelivery in hiveBox.values.toList()){
        if(!deliveryIds.contains(storedDelivery.id)){
          hiveBox.delete(storedDelivery.id);
        }
      }

      inProgressList = hiveBox.values.where((delivery) => delivery.status == "IN-PROGRESS").toList();
      pendingList = hiveBox.values.where((delivery) => delivery.status == "PENDING").toList();
      deliveredList = hiveBox.values.where((delivery) => delivery.status == "DELIVERED").toList();

      emit(state.copyWith(
        deliveriesStatus: DeliveriesStatus.success,
        messageStatus: "Success",
        inProgressList: inProgressList,
        pendingList: pendingList,
        deliveredList: deliveredList
      ));
    } catch(err){
      inProgressList = hiveBox.values.where((delivery) => delivery.status == "IN-PROGRESS").toList();
      pendingList = hiveBox.values.where((delivery) => delivery.status == "PENDING").toList();
      deliveredList = hiveBox.values.where((delivery) => delivery.status == "DELIVERED").toList();

      emit(state.copyWith(
        deliveriesStatus: DeliveriesStatus.error,
        messageStatus: err.toString(),
        inProgressList: inProgressList,
        pendingList: pendingList,
        deliveredList: deliveredList
      ));
      return;
    }
  }

  void getDelivery(String? id) {
    print(id);
    final Box<Delivery> box = Hive.box(_deliveriesBoxName);
    print(box.get(id));
    emit(state.copyWith(
      selectedDelivery: box.get(id),
    ));

    print(state.selectedDelivery);
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

  void search({String? contractNo}){
    emit(state.copyWith(deliveriesStatus: DeliveriesStatus.loading));

    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);

    if (contractNo == ""){
      final inProgressList = hiveBox.values.where((delivery) => delivery.status == "IN-PROGRESS").toList();
      final pendingList = hiveBox.values.where((delivery) => delivery.status == "PENDING").toList();
      final deliveredList = hiveBox.values.where((delivery) => delivery.status == "DELIVERED").toList();

      emit(state.copyWith(
        deliveriesStatus: DeliveriesStatus.success,
        inProgressList: inProgressList,
        pendingList: pendingList,
        deliveredList: deliveredList
      ));
      return;
    }

    final inProgressList = hiveBox.values.where((delivery) {
     return delivery.status == "IN-PROGRESS" && delivery.contractNo!.contains(contractNo!);
    }).toList();
    final pendingList = hiveBox.values.where((delivery) {
      return delivery.status == "PENDING" && delivery.contractNo!.contains(contractNo!);
    }).toList();
    final deliveredList = hiveBox.values.where((delivery) {
      return delivery.status == "DELIVERED" && delivery.contractNo!.contains(contractNo!);
    }).toList();

    emit(state.copyWith(
      deliveriesStatus: DeliveriesStatus.success,
      inProgressList: inProgressList,
      pendingList: pendingList,
      deliveredList: deliveredList
    ));
  }

  void getDeliveryByContractNo(String? contractNo){
    final Box<Delivery> box = Hive.box(_deliveriesBoxName);

    var searchedDelivery = box.values.where((delivery) {
     return delivery.contractNo!.contains(contractNo!);
    }).toList();

    emit(state.copyWith(messageStatus: ""));

    if(searchedDelivery.length == 0){
      emit(state.copyWith(messageStatus: "no_qr_found"));
      return;
    }

    emit(state.copyWith(
      selectedDelivery: box.get(searchedDelivery[0].id),
    ));
  }

  void fetchDeliveriesActivity() async{
    final Box<FailedDelivery> hiveBox = Hive.box(globalFailedDeliveriesBoxName);
    final deliveringList = hiveBox.values.toList();
    emit(state.copyWith(failedDeliveriesList: deliveringList));
  }

  void updateSelectedDelivery(Delivery delivery){
    emit(state.copyWith(selectedDelivery: delivery));
  }

  void updateDeliveryData(Delivery delivery){
    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    hiveBox.put(delivery.id, delivery);
    final inProgressList = hiveBox.values.where((delivery) => delivery.status == "IN-PROGRESS").toList();
    final pendingList = hiveBox.values.where((delivery) => delivery.status == "PENDING").toList();
    final deliveredList = hiveBox.values.where((delivery) => delivery.status == "DELIVERED").toList();

    emit(state.copyWith(
      inProgressList: inProgressList,
      pendingList: pendingList,
      deliveredList: deliveredList
    ));
  }

  void updateFailedDeliveryData({String? deliveryId, String? newStatus, String? newImagePath}){
    final Box<Delivery> hiveBox = Hive.box(_deliveriesBoxName);
    
    final Delivery deliveryToUpdate = hiveBox.get(deliveryId)!;
    final Delivery deliveryUpdated = Delivery.updateStatusAndImage(
      delivery: deliveryToUpdate,
      newStatus: newStatus,
      newImagePath: newImagePath
    );

    hiveBox.put(deliveryUpdated.id, deliveryUpdated);
    
    final inProgressList = hiveBox.values.where((delivery) => delivery.status == "IN-PROGRESS").toList();
    final pendingList = hiveBox.values.where((delivery) => delivery.status == "PENDING").toList();
    final deliveredList = hiveBox.values.where((delivery) => delivery.status == "DELIVERED").toList();

    emit(state.copyWith(
      inProgressList: inProgressList,
      pendingList: pendingList,
      deliveredList: deliveredList
    ));
  }
}
