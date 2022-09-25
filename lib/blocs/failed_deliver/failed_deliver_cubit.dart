import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/global_variables.dart';
import 'package:jnb_mobile/models/delivery.dart';
import 'package:jnb_mobile/models/failed_delivery.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';
import 'package:meta/meta.dart';

part 'failed_deliver_state.dart';

class FailedDeliverCubit extends Cubit<FailedDeliverState> {
  final DeliveryRepository _deliveryRepository;
  final DeliveriesCubit _deliveryCubit;

  FailedDeliverCubit({required DeliveryRepository deliveryRepository, required DeliveriesCubit deliveryCubit}) : 
    _deliveryRepository = deliveryRepository,
    _deliveryCubit = deliveryCubit,
    super(FailedDeliverState());

  // final String _deliveriesBoxName = 'deliveries';

  void redeliverFailedDeliveries() async {
    if(state.redeliverStatus == RedeliverStatus.delivering){
      emit(state.copyWith(redeliverStatus: RedeliverStatus.info));
      emit(state.copyWith(redeliverStatus: RedeliverStatus.delivering, statusMessage: "Already uploading deliveries"));
      return;
    }

    final Box<FailedDelivery> hiveBox = Hive.box(globalFailedDeliveriesBoxName);
    final failedDeliveries = hiveBox.values.toList();

    if(failedDeliveries.isEmpty){
      emit(state.copyWith(redeliverStatus: RedeliverStatus.unknown));
      emit(state.copyWith(redeliverStatus: RedeliverStatus.info, statusMessage: "No for upload deliveries yet"));
      return;
    }

    final int forUploadCount = failedDeliveries.length;

    emit(state.copyWith(
      forUploadCount: forUploadCount,
      uploadedCount: 0,
      redeliverStatus: RedeliverStatus.delivering, statusMessage: "Redelivering failed deliveries"));

    int uploadedCount = 0;

    // try {
      for(var failedDelivery in failedDeliveries){
        try{
          await _deliveryRepository.redeliver(
            failedDelivery: failedDelivery, 
          ).then((response) {
            _deliveryCubit.updateFailedDeliveryData(
              deliveryId: failedDelivery.id,
              newStatus: response.data['data']['status'],
              newImagePath: response.data['data']['image_path']
            );

            _removeFailedDelivery(failedDelivery);

            uploadedCount++;
            emit(state.copyWith(uploadedCount: uploadedCount));
          }).catchError((onError){
            throw Exception("Failed to upload: ${failedDelivery.contractNo}- ${failedDelivery.fullName}");
          });
        } catch(err){
          emit(state.copyWith(
            redeliverStatus: RedeliverStatus.failed, 
            statusMessage: err.toString()
          ));
        }
      }

      _deliveryCubit.fetchDeliveriesActivity();

      emit(state.copyWith(
        redeliverStatus: RedeliverStatus.delivered, 
        statusMessage: "Uploaded Successfully",
        forUploadCount: 0,
        uploadedCount: 0,
      ));

    // } catch (err) {
    //   emit(state.copyWith(
    //     redeliverStatus: RedeliverStatus.failed, 
    //     statusMessage: err.toString()
    //   ));
    // }
  }

  void _removeFailedDelivery(FailedDelivery delivery) {
    final Box<FailedDelivery> hiveBox = Hive.box(globalFailedDeliveriesBoxName);
    hiveBox.delete(delivery.id);
  }

  void removeFailedDelivery(FailedDelivery delivery) {
    final Box<FailedDelivery> failedDeliveriesBox = Hive.box(globalFailedDeliveriesBoxName);
    failedDeliveriesBox.delete(delivery.id);
    final Box<Delivery> deliveriesBox = Hive.box(globalDeliveriesBoxName);

    final Delivery deliveryToUpdate = deliveriesBox.get(delivery.id)!;

    final Delivery updatedDeliveryData = Delivery.updateStatusAndImage(
      delivery: deliveryToUpdate, 
      newStatus: "IN-PROGRESS",
      newImagePath: null
    );
    
    _deliveryCubit.updateDeliveryData(updatedDeliveryData);
    _deliveryCubit.fetchDeliveriesActivity();
  }
}
