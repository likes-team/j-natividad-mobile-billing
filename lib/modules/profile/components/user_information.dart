import 'package:flutter/material.dart';
import './widgets/texts.dart' show MyTextGrayWidget;

class UserInfoComponent extends StatelessWidget {
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
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          colors: [
            Color(0xff306A9B),
            Color(0xff7ED4D9),
          ],
          begin: FractionalOffset(0.0, 1.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    // backgroundImage: AssetImage('assets/user_default.png'),
                    radius: 60,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Robert Montemayor",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              margin: EdgeInsets.all(0),
              color: Colors.white,
              child: Column(
                children: [
                  Divider(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5, left: 30),
                    child: MyTextGrayWidget(
                        '70 Brighton Ct Brooklyn, NY 11235 USA'),
                  ),
                  Divider(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5, left: 30),
                    child: MyTextGrayWidget(
                      'January 21, 1994',
                    ),
                  ),
                  Divider(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 5, left: 30),
                    child: MyTextGrayWidget(
                      'jsmith@gmail.com',
                    ),
                  ),
                  Divider(
                    height: 24,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 20, left: 30),
                    child: MyTextGrayWidget(
                      '09173246193',
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
