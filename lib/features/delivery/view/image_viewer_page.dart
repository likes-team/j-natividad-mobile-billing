
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/utilities/colors.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends StatelessWidget {
  final File deliveryPhoto;
  final Delivery delivery;
  const ImageViewerPage({
    Key key, 
    @required this.deliveryPhoto,
    @required this.delivery
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Delivery Photo",
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
      body: Container(
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
       loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        imageProvider: delivery.status == "IN-PROGRESS" || delivery.status == "DELIVERING"
        ? FileImage(deliveryPhoto) : CachedNetworkImageProvider(delivery.imagePath),
      )
  ),
    );

  }
}