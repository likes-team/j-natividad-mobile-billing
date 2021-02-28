import 'package:flutter/material.dart';

// This is Code for Color Coding of status of Delivery
const pendingColor = Colors.orange; // 0
const deliveredColor = Colors.green; // 1
const inProgressColor = Colors.red; // 2
const deliveringColor = Colors.lightBlue; // 3
//

translateStatus(int code) {
  switch (code) {
    case 0:
      {
        return pendingColor;
      }
    case 1:
      {
        return deliveredColor;
      }
    case 2:
      {
        return inProgressColor;
      }
    case 3:
      {
        return deliveringColor;
      }
  }
}

statusName(int code) {
  switch (code) {
    case 0:
      {
        return 'PENDING';
      }
    case 1:
      {
        return 'DELIVERED';
      }
    case 2:
      {
        return 'INPROGRESS';
      }
    case 3:
      {
        return 'DELIVERING';
      }
  }
}

Widget deliveryTile(String title, String sub, int status, todo()) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(fontSize: 20),
    ),
    subtitle: Text(
      sub,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Card(
      color: translateStatus(status),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(statusName(status)),
      ),
    ),
    onTap: todo,
  );
}
