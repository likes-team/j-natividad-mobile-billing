import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/features/delivery/view/image_viewer_page.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:photo_view/photo_view.dart';

class DeliveryDetailComponent extends StatelessWidget {
  final Delivery delivery;
  final File deliveryPhoto;

  DeliveryDetailComponent(
      {Key key, @required this.delivery, this.deliveryPhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(0),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 15),
              child: Text(
                "Delivery Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.home,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title: Text(delivery.status),
                subtitle: Text("Status"),
                leading: Icon(Icons.history_edu),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                title:
                    deliveryPhoto == null && delivery.status == "IN-PROGRESS" ||
                            delivery.status == "DELIVERING"
                        ? Text(_getPhotoDetailMessage(
                            status: delivery.status,
                            deliveryPhoto: deliveryPhoto))
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageViewerPage(
                                          deliveryPhoto: deliveryPhoto,
                                          delivery: delivery,
                                  )));
                            },
                            child: Text(
                              "Click to view image",
                              style: TextStyle(color: AppColors.home),
                            )),
                subtitle: Text("Captured Photo"),
                leading: Icon(Icons.image),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhotoDetailMessage({String status, File deliveryPhoto}) {
    if (status == "DELIVERING") {
      return "Photo is uploading...";
    }

    if (deliveryPhoto == null) {
      return "No captured photo yet";
    }

    return "";
  }
}
