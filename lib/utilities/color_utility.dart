import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color.fromRGBO(0, 137, 123, 1);
  static const Color primary = Color(0xFF00796B);
  static const Color secondary = Colors.teal;
  static Color defaultYellowColor = const Color(0xFFfedd69);
  
  static Color? getColorFromDeliveryStatus({String? status}){
    if (status == "DELIVERED"){
      return Colors.green;
    } else if(status == "IN-PROGRESS"){
      return Colors.red;
    } else if(status == "PENDING"){
      return Colors.orange;
    } else if(status == "DELIVERING"){
      return Colors.blueGrey;
    }

    return null;
  }

  static Color getDisabledColorFromDeliveryStatus({String? status}){
    if(status == "IN-PROGRESS"){
      return Colors.white;
    }
    return Colors.grey;
  }
}