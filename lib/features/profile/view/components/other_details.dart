import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/colors.dart';

class OtherDetailsComponent extends StatelessWidget {
  final String _referralCodeSubtitle =
      '''Get exclusive freebies and discounts when you invite other nurses in\nthe platform. Give them your referral code below when they are\nsigning up to avail it!. ''';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 20),
            child: Text(
              "Others",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.home,
              ),
            ),
          ),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: Text('View Contract'),
                ),
                Divider(),
                ListTile(
                  title: Text('Suggestion Box'),
                ),
                Divider(),
                ListTile(
                  title: Text('Referral Code'),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      _referralCodeSubtitle,
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'A1B2-C3D4',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: AppColors.home,
                        ),
                      ),
                      Container(
                        width: 250,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Text(
                          "Log out",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
