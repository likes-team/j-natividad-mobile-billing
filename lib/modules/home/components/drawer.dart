import 'package:flutter/material.dart';
import '../../../utilities/colors.dart' show MyColors;

class DrawerComponent extends StatelessWidget {
  String _user_greeting = "Hi " + "Robert Montemayor" + "!";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            iconTheme: IconThemeData(color: MyColors.home),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Menu",
              style: TextStyle(
                color: MyColors.home,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xff306A9B),
                    const Color(0xff7ED4D9),
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 0.8],
                  tileMode: TileMode.clamp),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    // backgroundImage: AssetImage('assets/user_default.png'),
                    radius: 30,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    _user_greeting, // User Greeting here
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: Text('Notifications'),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text('Edit Profile'),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text('Change Password'),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text('Contact Us'),
              ),
              Divider(
                height: 1,
              ),
              ListTile(
                title: Text('Report a Bug'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
