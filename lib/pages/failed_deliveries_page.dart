import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/blocs/failed_deliver/failed_deliver_cubit.dart';
import 'package:jnb_mobile/components/failed_delivery_tile_component.dart';
import 'package:jnb_mobile/models/failed_delivery.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FailedDeliveriesPage extends StatefulWidget {
  @override
  _FailedDeliveriesPageState createState() => _FailedDeliveriesPageState();
}

class _FailedDeliveriesPageState extends State<FailedDeliveriesPage> {
  late DeliveriesCubit _deliveryCubit;
  late FailedDeliverCubit _failedDeliverCubit;

  @override
  void initState() {
    super.initState();

    // Get bloc instances
    _deliveryCubit = BlocProvider.of<DeliveriesCubit>(context);
    _failedDeliverCubit = BlocProvider.of<FailedDeliverCubit>(context);

    // Load initial data
    _deliveryCubit.fetchDeliveriesActivity();
  }

  _resendFailedDeliveries() {
    _failedDeliverCubit.redeliverFailedDeliveries();
  }

  _showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: BlocBuilder<FailedDeliverCubit, FailedDeliverState>(
        builder: (context, state) {
          return Container(
            height: 80,
            child: Column(
              children: [
                new Row(
                  children: [
                    const CircularProgressIndicator(),
                    Container(
                        margin: const EdgeInsets.only(left: 7),
                        child: const Text("Uploading, please wait...")),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20), child: Text("${state.uploadedCount} of ${state.forUploadCount}")),
              ],
            ),
          );
        },
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FailedDeliverCubit, FailedDeliverState>(
      listenWhen: (previous, current) {
        return previous.redeliverStatus != current.redeliverStatus;      
      },
      listener: (context, state) {
        if (state.redeliverStatus == RedeliverStatus.info) {
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage!,
            ),
          );
        } else if (state.redeliverStatus == RedeliverStatus.delivering) {
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage!,
            ),
          );
          _showLoaderDialog(context);
        } else if (state.redeliverStatus == RedeliverStatus.delivered) {
          Navigator.pop(context);
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.statusMessage!,
            ),
          );
        } else if (state.redeliverStatus == RedeliverStatus.failed) {
          Navigator.pop(context);
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: state.statusMessage!,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "For Upload Deliveries",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColors.primary,
          ),
        ),
        body: Center(
          child: BlocBuilder<DeliveriesCubit, DeliveryState>(
            builder: (context, state) {
              if (state.failedDeliveriesList == null ||
                  state.failedDeliveriesList!.isEmpty) {
                return const Text("Your for upload deliveries will display here.");
              }

              return ListView.builder(
                itemCount: state.failedDeliveriesList!.length,
                itemBuilder: (context, index) {
                  final FailedDelivery failedDelivery =
                      state.failedDeliveriesList![index];

                  return FailedDeliveryTileComponent(
                    id: failedDelivery.id,
                    title: failedDelivery.fullName,
                    subtitle: failedDelivery.subAreaName,
                    subtitle1: failedDelivery.areaName,
                    onTap: () {
                      _deliveryCubit.getDelivery(failedDelivery.id);
                      Navigator.pushNamed(context, '/delivery');
                    },
                    onConfirm: (){
                      _failedDeliverCubit.removeFailedDelivery(failedDelivery);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: AppColors.primary,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: _resendFailedDeliveries,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.upload_file, color: Colors.white),
                        Text("UPLOAD", style: TextStyle(color: Colors.white))
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
