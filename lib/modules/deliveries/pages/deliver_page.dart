import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/offline_manager/multipart_extended.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:jnb_mobile/utilities/urls.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart' as route;
import 'package:intl/intl.dart';
import 'package:jnb_mobile/modules/offline_manager/interceptors/dio_connectivity_request_retrier.dart';
import 'package:jnb_mobile/modules/offline_manager/interceptors/retry_interceptor.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/modules/deliveries/components/myLocationDetailComponent.dart';
import 'package:jnb_mobile/modules/deliveries/components/subscriber_detail_component.dart';
// import 'package:jnb_mobile/modules/deliveries/models/delivery.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:jnb_mobile/delivery.dart';

class DeliverPage extends StatefulWidget {
  final Delivery delivery;
  final int hiveIndex;

  DeliverPage({Key key, @required this.delivery, @required this.hiveIndex})
      : super(key: key);

  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  File _image;

  UserLocation userLocation;

  int messengerID;

  bool isDelivered;

  final picker = ImagePicker();

  Dio dio;

  final connectivity = Connectivity();

  final failedDeliveryService = FailedDeliveryService();

  @override
  void initState() {
    super.initState();

    UserPreferences().getUser().then((user) {
      messengerID = user.userID;
    });

    isDelivered = checkIfDelivered();

    dio = Dio();

    // dio.interceptors.add(
    //   RetryOnConnectionChangeInterceptor(
    //     requesetRetrier: DioConnectivityRequesetRetrier(
    //       dio: Dio(),
    //       connectivity: Connectivity(),
    //       context: context,
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  bool checkIfDelivered() {
    if (widget.delivery.status == "IN-PROGRESS") {
      return false;
    }

    return true;
  }

  Future deliver() async {
    showFlushbar(Flushbar(
      title: "Delivering!",
      message: "Please wait...",
      duration: Duration(seconds: 3),
    ));

    Delivery deliveryUpdateObject = Delivery(
      id: widget.delivery.id,
      deliveryDate: null,
      latitude: widget.delivery.latitude,
      longitude: widget.delivery.longitude,
      subscriberAddress: widget.delivery.subscriberAddress,
      subscriberEmail: widget.delivery.subscriberEmail,
      subscriberFname: widget.delivery.subscriberFname,
      subscriberLname: widget.delivery.subscriberLname,
      subscriberID: widget.delivery.subscriberID,
      status: "DELIVERING",
    );

    Provider.of<DeliveriesProvider>(context, listen: false).updateItem(
        widget.hiveIndex,
        deliveryUpdateObject); // Update yung status ng delivery sa hive

    DateTime dateNow = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateNow);
    String imageName = _image.path.split('/').last;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      failedDeliveryService.addFailedDelivery(
        delivery: widget.delivery,
        messengerID: messengerID,
        dateMobileDelivery: dateNow,
        imagePath: _image.path,
        latitude: userLocation.latitude.toString(),
        longitude: userLocation.longitude.toString(),
        accuracy: userLocation.accuracy.toString(),
        imageName: imageName,
      );
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });

      return Future.value(false);
    }

    FormData formData = new FormData.fromMap({
      'delivery_id': widget.delivery.id,
      'messenger_id': messengerID,
      'subscriber_id': widget.delivery.subscriberID,
      'date_mobile_delivery': formattedDate.toString(),
      'latitude': userLocation.latitude.toString(),
      'longitude': userLocation.longitude.toString(),
      'accuracy': userLocation.accuracy.toString(),
      "file": MultipartFileExtended.fromFileSync(
        _image.path,
        filename: imageName,
      ),
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      dio.post(AppUrls.deliverURL, data: formData).then((response) {
        Delivery deliveryUpdateObject = Delivery(
          id: widget.delivery.id,
          deliveryDate: null,
          latitude: widget.delivery.latitude,
          longitude: widget.delivery.longitude,
          subscriberAddress: widget.delivery.subscriberAddress,
          subscriberEmail: widget.delivery.subscriberEmail,
          subscriberFname: widget.delivery.subscriberFname,
          subscriberLname: widget.delivery.subscriberLname,
          subscriberID: widget.delivery.subscriberID,
          status: response.data['delivery']['status'],
        );

        Provider.of<DeliveriesProvider>(context, listen: false).updateItem(
            widget.hiveIndex,
            deliveryUpdateObject); // Update yung status ng delivery sa hive

        Navigator.pop(context);
        Navigator.pop(context);

        showFlushbar(Flushbar(
          title: "Delivered Successfully!",
          message: "Check dashboard for more details.",
          duration: Duration(seconds: 3),
        ));
      }).catchError((error) {
        Flushbar(
          title: "Deliver Failed!",
          message: "Error occured, please contact system administrator.",
          duration: Duration(seconds: 3),
        ).show(context);
      });
    });

    return Future.value(true);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Widget imageWidget() {
    if (isDelivered == true) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Text('Fetching image...'),
        ),
      );
    }

    if (_image == null) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Text('No image captured.'),
        ),
      );
    }

    return Image.file(_image);
  }

  Future showFlushbar(Flushbar instance) {
    final _route = route.showFlushbar(
      context: context,
      flushbar: instance,
    );

    return Navigator.of(context, rootNavigator: true).push(_route);
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
            child: isDelivered == false
                ? FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    // Provide an onPressed callback.
                    onPressed: getImage,
                  )
                : SizedBox(),
          ),
          _image != null
              ? FloatingActionButton(
                  heroTag: "btnDeliver",
                  onPressed: deliver,
                  child: Icon(Icons.send),
                  backgroundColor: Colors.green,
                )
              : SizedBox(), // Walang ipapakita na send button
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Delivery",
          style: TextStyle(
            color: MyColors.home,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: MyColors.home,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SubscriberDetailComponent(delivery: widget.delivery),
              MyLocationDetailComponent(
                location: userLocation?.fullLocation?.toString(),
              ),
              imageWidget(), // tinawag ang function na nag rereturn ng Widget()
            ],
          ),
        ),
      ),
    );
  }
}
