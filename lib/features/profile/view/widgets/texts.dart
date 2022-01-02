import 'package:flutter/material.dart';

class MyTextGrayWidget extends StatelessWidget {
  final String text;

  MyTextGrayWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.grey[600], fontSize: 16),
    );
  }
}
