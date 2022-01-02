import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/features/delivery/bloc/failed_deliver/failed_deliver_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/components/failed_delivery_tile_component.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FailedDeliveriesPage extends StatefulWidget {
  @override
  _FailedDeliveriesPageState createState() => _FailedDeliveriesPageState();
}

class _FailedDeliveriesPageState extends State<FailedDeliveriesPage> {
  DeliveryCubit _deliveryCubit;
  FailedDeliverCubit _failedDeliverCubit;

  @override
  void initState() {
    super.initState();

    // Get bloc instances
    _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);
    _failedDeliverCubit = BlocProvider.of<FailedDeliverCubit>(context);

    // Load initial data
    _deliveryCubit.fetchDeliveriesActivity();
  }

  _resendFailedDeliveries() {
    _failedDeliverCubit.redeliverFailedDeliveries();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FailedDeliverCubit, FailedDeliverState>(
      listener: (context, state) {
        if(state.redeliverStatus == RedeliverStatus.info){
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage,
            ),
          );
        } else if(state.redeliverStatus == RedeliverStatus.delivering){
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage,
            ),
          );
        } else if(state.redeliverStatus == RedeliverStatus.delivered){
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.statusMessage,
            ),
          );
        } else if (state.redeliverStatus == RedeliverStatus.failed) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: state.statusMessage,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Failed Deliveries",
            style: TextStyle(
              color: AppColors.home,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.home,
          ),
        ),
        body: Center(
          child: BlocBuilder<DeliveryCubit, DeliveryState>(
            builder: (context, state) {
              if (state.failedDeliveriesList == null ||
                  state.failedDeliveriesList.isEmpty) {
                return Text(
                    "Your failed deliveries will display here.");
              }

              return ListView.builder(
                itemCount: state.failedDeliveriesList.length,
                itemBuilder: (context, index) {
                  final FailedDelivery failedDelivery = state.failedDeliveriesList[index];

                  return FailedDeliveryTileComponent(
                    id: failedDelivery.id,
                    title: failedDelivery.fullName,
                    subtitle: failedDelivery.subAreaName,
                    subtitle1: failedDelivery.areaName,
                    onTap: () {
                      _deliveryCubit.getDelivery(failedDelivery.id);
                      Navigator.pushNamed(
                          context, '/delivery');
                    },
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.home,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: _resendFailedDeliveries,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.upload_file, color: Colors.white),
                        Text("REDELIVER ALL",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
