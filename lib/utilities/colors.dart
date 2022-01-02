// Custom colors
import 'package:flutter/material.dart'
    show Colors, MaterialAccentColor, MaterialColor, Color;

class AppColors {
  AppColors._();

  static const MaterialAccentColor home = Colors.blueAccent;
  static const MaterialColor away = Colors.red;
  static Color accent = Colors.teal.shade600;
  static Color primary = Colors.teal.shade700;
  static Color secondary = Colors.teal.shade800;


  static Color getColorFromDeliveryStatus({String status}){
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

  static Color getDisabledColorFromDeliveryStatus({String status}){
    if(status == "IN-PROGRESS"){
      return Colors.white;
    }
    return Colors.grey;
  }
}
