import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/location_updater/components/myLocationDetailUpdaterComponent.dart';
import 'package:jnb_mobile/modules/location_updater/components/subscriber_detail_updater_component.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:jnb_mobile/utilities/urls.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:jnb_mobile/delivery.dart';

class UpdatePage extends StatefulWidget {
  final Delivery delivery;

  UpdatePage({Key key, @required this.delivery})
      : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  UserLocation userLocation;

  String messengerID;

  final picker = ImagePicker();

  Dio dio;

  final connectivity = Connectivity();

  final failedDeliveryService = FailedDeliveryService();

  bool isUpdating;

  @override
  void initState() {
    super.initState();

    UserPreferences.getUser().then((user) {
      messengerID = user.id;
    });

    dio = Dio();

    isUpdating = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future updateLocation() async {
    setState(() {
      isUpdating = true;
    });

    BotToast.showSimpleNotification(
      title: "Updating Location, Please wait...",
      backgroundColor: Colors.blue[200],
    );

    var selectedArea =
        Provider.of<AreasProvider>(context, listen: false).selectedArea;

    var selectedSubArea =
        Provider.of<AreasProvider>(context, listen: false).selectedSubArea;

    Delivery deliveryUpdateObject = Delivery(
      id: widget.delivery.id,
      deliveryDate: widget.delivery.deliveryDate,
      latitude: userLocation.latitude.toString(),
      longitude: userLocation.longitude.toString(),
      subscriberAddress: widget.delivery.subscriberAddress,
      subscriberEmail: widget.delivery.subscriberEmail,
      subscriberFname: widget.delivery.subscriberFname,
      subscriberLname: widget.delivery.subscriberLname,
      subscriberID: widget.delivery.subscriberID,
      areaID: widget.delivery.areaID,
      areaName: widget.delivery.areaName,
      subAreaID: widget.delivery.subAreaID,
      subAreaName: widget.delivery.subAreaName,
      status: widget.delivery.status,
    );

    Provider.of<DeliveriesProvider>(context, listen: false).updateItem(
        deliveryUpdateObject,
        selectedArea,
        selectedSubArea); // Update yung location ng subscriber sa hive

    Provider.of<DeliveriesProvider>(context, listen: false)
        .selectDelivery(widget.delivery.id);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Map<String, dynamic> postData = {
          "latitude": userLocation.latitude.toString(),
          "longitude": userLocation.longitude.toString(),
          "accuracy": userLocation.accuracy.toString(),
          "messenger_id": messengerID,
          "subscriber_id": widget.delivery.subscriberID,
        };

        Future.delayed(Duration(milliseconds: 1000), () {
          dio.post(AppUrls.updateLocationURL, data: postData).then((response) {
            Navigator.pop(context);

            BotToast.showSimpleNotification(
              title: "Location Updated Successfully!",
              subTitle: "You can now perform delivery for this subscriber.",
              backgroundColor: Colors.green,
            );
          }).catchError((error) {
            BotToast.showSimpleNotification(
              title: "Error Occured!",
              subTitle:
                  "Error occured, please contact system administrator or try again.",
              backgroundColor: Colors.red,
            );
          });
        });

        if (this.mounted) {
          setState(() {
            isUpdating = false;
          });
        }

        return Future.value(true);
      }
    } on SocketException catch (_) {
      BotToast.showSimpleNotification(
        title: "No Internet",
        subTitle: "Updating with last identified location.",
        backgroundColor: Colors.yellow[200],
      );

      if (this.mounted) {
        setState(() {
          isUpdating = false;
        });
      }

      Navigator.pop(context);

      return Future.value(false);
    }
  }

  Widget setUpUpdateButton() {
    if (isUpdating == true) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

    return Icon(Icons.edit_location_sharp);
  }

  @override
  Widget build(BuildContext context) {
    userLocation = Provider.of<UserLocation>(context);

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                tooltip: "Update location",
                child: setUpUpdateButton(),
                // Provide an onPressed callback.
                onPressed: isUpdating == false ? updateLocation : () => {},
              )),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Update Location",
          style: TextStyle(
            color: AppColors.home,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.home,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SubscriberDetailUpdaterComponent(delivery: widget.delivery),
              MyLocationDetailUpdaterComponent(
                location: userLocation?.fullLocation?.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
