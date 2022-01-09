import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/colors.dart';

class FailedDeliveryTileComponent extends StatelessWidget {
  const FailedDeliveryTileComponent({
    Key key,
    this.title,
    this.subtitle,
    this.subtitle1,
    this.profilePicture,
    this.onTap,
    @required this.id,
    this.isJoined
  }) : super(key: key);
  final String title;
  final String subtitle;
  final String subtitle1;
  final String profilePicture;
  final VoidCallback onTap;
  final String id;
  final bool isJoined;
  

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
                title: Text(
                  title,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                 subtitle: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        subtitle1,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      
                    ],
                  ),
                ),
                tileColor: Colors.white,
                // trailing: Container(
                //   width: 110,
                //   child: Align(
                //       alignment: Alignment.centerRight,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           // Container(
                //           //   margin: EdgeInsets.only(left: 50),
                //           //   child: TextButton(
                //           //     onPressed: () async {
                //           //     },
                //           //     style: TextButton.styleFrom(
                //           //       padding: EdgeInsets.zero,
                //           //       minimumSize: Size(50, 25),
                //           //       backgroundColor: AppColors.secondary,
                //           //       shape: RoundedRectangleBorder(
                //           //         borderRadius: BorderRadius.circular(
                //           //           5,
                //           //         ),
                //           //       ),
                //           //     ),
                //           //     child: Text('Redeliver',
                //           //       style: TextStyle(
                //           //         color: Colors.white,
                //           //         fontSize: 10,
                //           //       ),
                //           //     ),
                //           //   ),
                //           // ),
                      
                //         ],
                //       )),
                // ),
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