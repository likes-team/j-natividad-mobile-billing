import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/colors.dart';

class MyLocationDetailUpdaterComponent extends StatelessWidget {
  final location;

  MyLocationDetailUpdaterComponent({Key key, @required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
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
              margin: EdgeInsets.only(top: 15, left: 30, bottom: 15),
              child: Text(
                "Current Location Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.home,
                ),
              ),
            ),
            Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5, left: 10),
              child: ListTile(
                title: Text(
                    location ?? "Cannot get current location, please wait..."),
                leading: Icon(Icons.pin_drop,
                    color: location != null ? Colors.green : Colors.red),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
