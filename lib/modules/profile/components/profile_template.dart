import 'package:flutter/material.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';

class ProfileTemplate extends StatelessWidget {
  final firstname;
  final lastname;
  final username;
  final picturepath;
  const ProfileTemplate(
      {Key key, this.firstname, this.lastname, this.username, this.picturepath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileSize = MediaQuery.of(context).size.width -
        ((MediaQuery.of(context).size.width / 2) + 85);

    var logoutUser = () {
      UserPreferences().removeUser();
      Navigator.pushReplacementNamed(context, '/login');
    };
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.all(70),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF23395B),
                      Color(0xFF406E8E),
                      Color(0xFF8EA8C3),
                    ], begin: Alignment.topCenter, end: Alignment.bottomRight),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      children: [
                        Text(
                          this.firstname + " " + this.lastname,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(this.username),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF161925)),
                          onPressed: logoutUser,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              'Logout',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          )),
                    ),
                  )),
              Flexible(
                flex: 2,
                child: Container(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image(
                        height: 30,
                        image: AssetImage('assets/image/logo.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            right: profileSize,
            left: profileSize,
            child: Container(
              height: 170,
              width: 170,
              child: FittedBox(
                fit: BoxFit.contain,
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/image/default-avatar.jpg'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
