import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/features/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/components/update_location_modal.dart';
import 'package:jnb_mobile/features/location/bloc/location_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/components/delivery_detail_component.dart';
import 'package:jnb_mobile/features/delivery/view/components/subscriber_detail_component.dart';
import 'package:jnb_mobile/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DeliverPage extends StatefulWidget {
  // final Delivery delivery;
  // final int hiveIndex;

  DeliverPage({Key key}) : super(key: key);

  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  AuthenticationBloc _authenticationBloc;
  DeliveryCubit _deliveryCubit;
  LocationCubit _userLocation;

  File _deliveryPhoto;

  String messengerID;

  bool isDelivered; // Pag status ay delivered na

  bool isDelivering = false; // Pag status ay delivering palang

  bool hasImage = false;

  final picker = ImagePicker();

  Dio dio;

  final connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    // Get bloc instances
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _deliveryCubit = BlocProvider.of<DeliveryCubit>(context);
    _userLocation = BlocProvider.of<LocationCubit>(context);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  void _onPressedDeliver() {
    _deliveryCubit.deliver(_deliveryCubit.state.selectedDelivery,
        _deliveryPhoto, _userLocation.state);
  }

  Future capturePhoto() async {
    if (_deliveryCubit.state.selectedDelivery.status != "IN-PROGRESS") {
      return;
    }

    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      if (pickedFile != null) {
        _deliveryPhoto = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryCubit, DeliveryState>(
      listener: (context, state) {
        if (state.deliverStatus == DeliverStatus.delivering) {
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              message: state.statusMessage,
            ),
          );
        } else if (state.deliverStatus == DeliverStatus.delivered) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: state.statusMessage,
            ),
          );
        } else if (state.deliverStatus == DeliverStatus.failed) {
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
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Delivery",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.home,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(
            color: AppColors.home,
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              height: 24.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: AppColors.home,
                child: Center(
                  child: BlocBuilder<LocationCubit, UserLocation>(
                    builder: (context, state) {
                      return Text(
                          "Your Location: ${state?.fullLocation}");
                    },
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      BlocBuilder<DeliveryCubit, DeliveryState>(
                        builder: (context, state) {
                          return SubscriberDetailComponent(
                              delivery: state.selectedDelivery);
                        },
                      ),
                      BlocBuilder<LocationCubit, UserLocation>(
                        builder: (context, state) {
                          return DeliveryDetailComponent(
                            delivery: _deliveryCubit.state.selectedDelivery,
                            deliveryPhoto: _deliveryPhoto,
                          );
                        },
                      ),
                      // imageWidget(
                      //     deliveriesProvider), // tinawag ang function na nag rereturn ng Widget()
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                  onTap: capturePhoto,
                  child: Container(
                    child: BlocBuilder<DeliveryCubit, DeliveryState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.camera,
                                color: AppColors
                                    .getDisabledColorFromDeliveryStatus(
                                        status: state.selectedDelivery.status)),
                            Text(
                                _deliveryPhoto == null
                                    ? "CAPTURE"
                                    : "RECAPTURE",
                                style: TextStyle(
                                    color: AppColors
                                        .getDisabledColorFromDeliveryStatus(
                                            status:
                                                state.selectedDelivery.status),
                                    fontSize: 12))
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 5,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _onPressedDeliver();
                  },
                  child: Container(
                    child: BlocBuilder<DeliveryCubit, DeliveryState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.upload_file,
                                color: AppColors
                                    .getDisabledColorFromDeliveryStatus(
                                        status: state.selectedDelivery.status)),
                            Text("DELIVER",
                                style: TextStyle(
                                    color: AppColors
                                        .getDisabledColorFromDeliveryStatus(
                                            status:
                                                state.selectedDelivery.status),
                                    fontSize: 12))
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 5,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateLocationModal());
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.edit_location, color: Colors.white),
                        Text("UPDATE LOCATION",
                            style: TextStyle(color: Colors.white, fontSize: 11))
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
