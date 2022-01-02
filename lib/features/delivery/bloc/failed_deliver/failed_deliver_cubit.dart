import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:meta/meta.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';
import 'package:jnb_mobile/utilities/globals.dart';

part 'failed_deliver_state.dart';

class FailedDeliverCubit extends Cubit<FailedDeliverState> {
  final DeliveryRepository _deliveryRepository;
  final DeliveryCubit _deliveryCubit;

  FailedDeliverCubit({@required DeliveryRepository deliveryRepository, @required DeliveryCubit deliveryCubit}) : 
    _deliveryRepository = deliveryRepository,
    _deliveryCubit = deliveryCubit,
    super(FailedDeliverState());

  // final String _deliveriesBoxName = 'deliveries';

  void redeliverFailedDeliveries() async {
    if(state.redeliverStatus == RedeliverStatus.delivering){
      emit(state.copyWith(redeliverStatus: RedeliverStatus.info));
      emit(state.copyWith(redeliverStatus: RedeliverStatus.delivering, statusMessage: "Already redelivering failed deliveries"));
      return;
    }

    final Box<FailedDelivery> hiveBox = Hive.box(AppGlobals.failedDeliveriesBoxName);
    final failedDeliveries = hiveBox.values.toList();
    print("failedDeliveries");
    print(failedDeliveries);

    if(failedDeliveries.isEmpty){
      emit(state.copyWith(redeliverStatus: RedeliverStatus.unknown));
      emit(state.copyWith(redeliverStatus: RedeliverStatus.info, statusMessage: "No failed deliveries yet"));
      return;
    }

    emit(state.copyWith(redeliverStatus: RedeliverStatus.delivering, statusMessage: "Redelivering failed deliveries"));

    try {
      for(var failedDelivery in failedDeliveries){
        _deliveryRepository.redeliver(
          failedDelivery: failedDelivery, 
        ).then((response) {
          emit(state.copyWith(
            redeliverStatus: RedeliverStatus.delivered, 
            statusMessage: "Delivered Successfully"
          ));

          _deliveryCubit.updateFailedDeliveryData(
            deliveryId: failedDelivery.id,
            newStatus: response.data['data']['status'],
            newImagePath: response.data['data']['image_path']
          );

          _removeFailedDelivery(failedDelivery);
          _deliveryCubit.fetchDeliveriesActivity();
        }).catchError((onError){
          emit(state.copyWith(
            redeliverStatus: RedeliverStatus.failed, 
            statusMessage: "Redeliver Failed, resend when internet is available."
          ));
        });
      }
    } catch (err) {
      emit(state.copyWith(
        redeliverStatus: RedeliverStatus.failed, 
        statusMessage: err.toString()
      ));
    }
  }

  void _removeFailedDelivery(FailedDelivery delivery) {
    final Box<FailedDelivery> hiveBox = Hive.box(AppGlobals.failedDeliveriesBoxName);
    hiveBox.delete(delivery.id);
  }
}
