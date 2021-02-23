import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/authentication/pages/login.dart';
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/modules/authentication/providers/authentication.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart'
    show UserPreferences;
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'JNatividadBilling',
        home: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.data.username == null)
                  return LoginPage();
                else
                  UserPreferences().removeUser();
                return Home();
            }
          },
        ),
        routes: {'/deliveries': (context) => Home()},
      ),
    );
  }
}
