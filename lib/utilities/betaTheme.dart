import 'package:flutter/material.dart';

ThemeData betaTheme() {
  TextTheme betaTextTheme(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1.copyWith(
          fontFamily: 'Montserrat',
          fontSize: 22.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline4: base.headline4.copyWith(
          fontFamily: 'Montserrat',
          fontSize: 14.0,
          color: Colors.white,
        ));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: betaTextTheme(base.textTheme),
    primaryColor: Colors.black,
  );
}
