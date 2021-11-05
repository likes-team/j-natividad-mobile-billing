import 'package:flutter/material.dart';
import '../../../utilities/colors.dart' show AppColors;
import './widgets/texts.dart' show MyTextGrayWidget;

class BankDetailsComponent extends StatelessWidget {
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
              margin: EdgeInsets.only(top: 15, left: 30),
              child: Text(
                "Bank Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.home,
                ),
              ),
            ),
            Divider(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5, left: 30),
              child: MyTextGrayWidget(
                'Account No.: ' + '1234 5678 9012',
              ),
            ),
            Divider(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5, left: 30),
              child: MyTextGrayWidget(
                'Account Name: ' + 'Jane G. Smith',
              ),
            ),
            Divider(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 5, left: 30),
              child: MyTextGrayWidget(
                'Bank Name: ' + 'JP Morgan & Chase',
              ),
            ),
            Divider(
              height: 25,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 20, left: 30),
              child: MyTextGrayWidget(
                'Contact No.: ' + '+639173246193',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
