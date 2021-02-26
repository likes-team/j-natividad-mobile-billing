import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jnb_mobile/modules/authentication/pages/login.dart';
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/modules/location/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/modules/authentication/providers/authentication.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart'
    show UserPreferences;
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        StreamProvider<UserLocation>(
          create: (context) => LocationService().locationStream,
        )
      ],
      child: MaterialApp(
        title: 'JNatividadBilling',
        routes: {
          '/deliveries': (context) => Home(),
          '/login': (context) => LoginPage()
        },
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
                else if (snapshot.data.userID == null) return LoginPage();

                return Home();
            }
          },
        ),
      ),
    );
  }
}
