import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/location_updater/pages/update_page.dart';
import 'package:jnb_mobile/modules/offline_manager/multipart_extended.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'package:jnb_mobile/utilities/urls.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import 'package:jnb_mobile/modules/offline_manager/interceptors/dio_connectivity_request_retrier.dart';
// import 'package:jnb_mobile/modules/offline_manager/interceptors/retry_interceptor.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/modules/deliveries/components/myLocationDetailComponent.dart';
import 'package:jnb_mobile/modules/deliveries/components/subscriber_detail_component.dart';
// import 'package:jnb_mobile/modules/deliveries/models/delivery.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:jnb_mobile/delivery.dart';

class DeliverPage extends StatefulWidget {
  // final Delivery delivery;
  // final int hiveIndex;

  DeliverPage({Key key}) : super(key: key);

  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  File _image;

  UserLocation userLocation;

  int messengerID;

  bool isDelivered; // Pag status ay delivered na

  bool isDelivering = false; // Pag status ay delivering palang

  bool hasImage = false;

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

    DeliveriesProvider _initProvider =
        Provider.of<DeliveriesProvider>(context, listen: false);
    isDelivered = checkIfDelivered(_initProvider);

    hasImage = checkIfDelivered(_initProvider);

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

  bool checkIfDelivered(DeliveriesProvider deliveriesProvider) {
    if (deliveriesProvider.selectedDelivery.status == "IN-PROGRESS") {
      return false;
    }

    return true;
  }

  Future deliver(
      BuildContext context, DeliveriesProvider deliveriesProvider) async {
    setState(() {
      isDelivering = true;
    });

    BotToast.showSimpleNotification(
      title: "Delivering, Please wait...",
      backgroundColor: Colors.blue[200],
    );

    Delivery deliveryUpdateObject = Delivery(
      id: deliveriesProvider.selectedDelivery.id,
      deliveryDate: null,
      latitude: deliveriesProvider.selectedDelivery.latitude,
      longitude: deliveriesProvider.selectedDelivery.longitude,
      subscriberAddress: deliveriesProvider.selectedDelivery.subscriberAddress,
      subscriberEmail: deliveriesProvider.selectedDelivery.subscriberEmail,
      subscriberFname: deliveriesProvider.selectedDelivery.subscriberFname,
      subscriberLname: deliveriesProvider.selectedDelivery.subscriberLname,
      subscriberID: deliveriesProvider.selectedDelivery.subscriberID,
      areaID: deliveriesProvider.selectedDelivery.areaID,
      areaName: deliveriesProvider.selectedDelivery.areaName,
      subAreaID: deliveriesProvider.selectedDelivery.subAreaID,
      subAreaName: deliveriesProvider.selectedDelivery.subAreaName,
      status: "DELIVERING",
    );

    deliveriesProvider.updateItem(
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
      BotToast.showSimpleNotification(
        title: "No Internet",
        subTitle: "Delivery will resend when internet is available.",
        backgroundColor: Colors.yellow[200],
      );

      failedDeliveryService.addFailedDelivery(
        delivery: deliveriesProvider.selectedDelivery,
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
      });

      return Future.value(false);
    }

    FormData formData = new FormData.fromMap({
      'delivery_id': deliveriesProvider.selectedDelivery.id,
      'messenger_id': messengerID,
      'subscriber_id': deliveriesProvider.selectedDelivery.subscriberID,
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
          id: deliveriesProvider.selectedDelivery.id,
          deliveryDate: null,
          latitude: deliveriesProvider.selectedDelivery.latitude,
          longitude: deliveriesProvider.selectedDelivery.longitude,
          subscriberAddress:
              deliveriesProvider.selectedDelivery.subscriberAddress,
          subscriberEmail: deliveriesProvider.selectedDelivery.subscriberEmail,
          subscriberFname: deliveriesProvider.selectedDelivery.subscriberFname,
          subscriberLname: deliveriesProvider.selectedDelivery.subscriberLname,
          subscriberID: deliveriesProvider.selectedDelivery.subscriberID,
          areaID: deliveriesProvider.selectedDelivery.areaID,
          areaName: deliveriesProvider.selectedDelivery.areaName,
          subAreaID: deliveriesProvider.selectedDelivery.subAreaID,
          subAreaName: deliveriesProvider.selectedDelivery.subAreaName,
          status: response.data['delivery']['status'],
        );

        deliveriesProvider.updateItem(
            deliveryUpdateObject); // Update yung status ng delivery sa hive

        if (this.mounted) {
          setState(() {
            isDelivering = false;
            isDelivered = true;
          });
        }

        BotToast.showSimpleNotification(
          title: "Delivered Successfully",
          subTitle: " Check dashboard for more details.",
          backgroundColor: Colors.green,
        );

        Navigator.pop(context);
      }).catchError((error) {
        if (this.mounted) {
          setState(() {
            isDelivering = false;
          });
        }

        BotToast.showSimpleNotification(
          title: "Deliver Failed",
          duration: Duration(seconds: 5),
          subTitle:
              "Error occured, please contact system administrator\n Error: $error",
          backgroundColor: Colors.red,
        );
      });
    });

    return Future.value(true);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        hasImage = true;
      }
    });
  }

  Widget imageWidget(DeliveriesProvider deliveriesProvider) {
    if (isDelivered == true) {
      return Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Text('Fetching image...'),
        ),
      );
    }

    if (deliveriesProvider.selectedDelivery.coordinates == null) {
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 75),
          child: Text(
            "No subscriber coordinates!, please update subscriber coordinates first to capture an image.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
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

  Widget setUpDeliverButton() {
    if (isDelivering == true) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

    if (isDelivered == false) {
      return Icon(Icons.send);
    }

    return Icon(Icons.check, color: Colors.white);
  }

  _goToLocationUpdaterPage(
      BuildContext context, DeliveriesProvider deliveriesProvider) {
    Navigator.of(context).push(_createRoute(context, deliveriesProvider));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   model.valueThatComesFromAProvider = Provider.of<MyDependency>(context);
  // }

  Route _createRoute(
      BuildContext context, DeliveriesProvider deliveriesProvider) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UpdatePage(
        delivery: deliveriesProvider.selectedDelivery, // Ipasa ang data
        hiveIndex: deliveriesProvider.selectedDelivery.id,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    userLocation = Provider.of<UserLocation>(context);
    DeliveriesProvider deliveriesProvider =
        Provider.of<DeliveriesProvider>(context);

    // to be continued, convert parameters to provider values to update values after location update

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          deliveriesProvider.selectedDelivery.coordinates == null
              ? FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () =>
                      _goToLocationUpdaterPage(context, deliveriesProvider),
                  tooltip: "Update subscriber's location",
                )
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: isDelivered == false &&
                    deliveriesProvider.selectedDelivery.coordinates != null &&
                    isDelivering == false
                ? FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: getImage,
                  )
                : SizedBox(),
          ),
          hasImage != false
              ? FloatingActionButton(
                  child: setUpDeliverButton(),
                  heroTag: "btnDeliver",
                  onPressed: isDelivered == false
                      ? () => deliver(context, deliveriesProvider)
                      : () => {},
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
              Consumer<DeliveriesProvider>(
                builder: (context, provider, _) {
                  return SubscriberDetailComponent(
                      delivery: provider.selectedDelivery);
                },
              ),
              MyLocationDetailComponent(
                location: userLocation?.fullLocation?.toString(),
              ),
              imageWidget(
                  deliveriesProvider), // tinawag ang function na nag rereturn ng Widget()
            ],
          ),
        ),
      ),
    );
  }
}
