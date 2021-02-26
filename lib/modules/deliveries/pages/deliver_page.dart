import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/utilities/urls.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/modules/deliveries/components/myLocationDetailComponent.dart';
import 'package:jnb_mobile/modules/deliveries/components/subscriber_detail_component.dart';
import 'package:jnb_mobile/modules/deliveries/models/delivery.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/utilities/colors.dart';

class DeliverPage extends StatefulWidget {
  final Delivery delivery;

  DeliverPage({Key key, @required this.delivery}) : super(key: key);

  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  bool isCameraReady = false;

  bool showCapturedPhoto = false;

  String imagePath;

  File _image;

  final picker = ImagePicker();

  UserLocation userLocation;

  int messengerID;

  @override
  void initState() {
    super.initState();

    UserPreferences().getUser().then((user) {
      messengerID = user.userID;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  Future deliver() async {
    Flushbar(
      title: "Delivering!",
      message: "Please wait...",
      duration: Duration(seconds: 3),
    ).show(context);

    DateTime dateNow = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(dateNow);

    String imageName = _image.path.split('/').last;

    FormData formData = new FormData.fromMap({
      'delivery_id': widget.delivery.id,
      'messenger_id': messengerID,
      'subscriber_id': widget.delivery.subscriberID,
      'date_mobile_delivery': formattedDate.toString(),
      'latitude': userLocation.latitude.toString(),
      'longitude': userLocation.longitude.toString(),
      'accuracy': userLocation.accuracy.toString(),
      "file": await MultipartFile.fromFile(
        _image.path,
        filename: imageName,
      ),
    });
    Dio dio = new Dio();

    dio.post(AppUrls.deliverURL, data: formData).then((response) {
      Flushbar(
        title: "Delivered Successfully!",
        message: "Check dashboard for more details.",
        duration: Duration(seconds: 3),
      ).show(context);
    }).catchError((error) {
      Flushbar(
        title: "Deliver Failed!",
        message: "Error occured, please contact system administrator.",
        duration: Duration(seconds: 3),
      ).show(context);
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
              child: Icon(Icons.camera_alt),
              // Provide an onPressed callback.
              onPressed: getImage,
            ),
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
              Center(
                child: _image == null
                    ? Text('No image captured.')
                    : Image.file(_image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
