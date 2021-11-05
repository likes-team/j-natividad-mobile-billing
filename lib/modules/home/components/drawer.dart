import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/about/pages/about.dart';
import '../../../utilities/colors.dart' show AppColors;

class DrawerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var logoutUser = () {
    //   UserPreferences().removeUser();
    //   Navigator.pushReplacementNamed(context, '/login');
    // };

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            iconTheme: IconThemeData(color: AppColors.home),
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
                color: AppColors.home,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: Text('About'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              )
              // ListTile(
              //   title: Text('Notifications'),
              // ),
              // Divider(
              //   height: 1,
              // ),
              // ListTile(
              //   title: Text('Edit Profile'),
              // ),
              // Divider(
              //   height: 1,
              // ),
              // ListTile(
              //   title: Text('Change Password'),
              // ),
              // Divider(
              //   height: 1,
              // ),
              // ListTile(
              //   title: Text('Contact Us'),
              // ),
              // Divider(
              //   height: 1,
              // ),
              // ListTile(
              //   title: Text('Report a Bug'),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
