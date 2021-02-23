import 'package:flutter/material.dart';
import '../../../utilities/colors.dart' show MyColors;

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  @override
  final Size preferredSize;

  AppBarComponent({Key key, this.title})
      : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.home),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: MyColors.home,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
