import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/colors.dart';

class DeliveryTile extends StatelessWidget {
  const DeliveryTile({
    Key key,
    this.title,
    this.subtitle,
    this.onTap,
    this.subtitle2,
    this.subtitle3,
    this.subtitle4 = "",
  }) : super(key: key);
  final String title;
  final String subtitle;
  final String subtitle2;
  final String subtitle3;
  final String subtitle4;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 1, 10, 1),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                // leading: CircleAvatar(
                //   backgroundColor: Colors.grey[200],
                //   radius: 25,
                //   backgroundImage: profilePicture ?? AssetImage("assets/default_user.png"),
                // ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: AppColors.home,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle3,
                      style: TextStyle(
                        color: AppColors.getColorFromDeliveryStatus(status: subtitle3),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.accent,  
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        subtitle4,
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                         SizedBox(
                        height: 5,
                      ),
                      Text(
                      subtitle2,
                      style: TextStyle(
                        color:  Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}