import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:jnb_mobile/areas.dart';
import 'package:jnb_mobile/delivery.dart';
import 'package:jnb_mobile/failed_delivery.dart';
import 'package:jnb_mobile/modules/authentication/pages/login.dart';
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:jnb_mobile/modules/deliveries/providers/areas_provider.dart';
import 'package:jnb_mobile/modules/deliveries/providers/deliveries_provider.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/modules/location/services/location_service.dart';
import 'package:jnb_mobile/sub_areas.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/modules/authentication/providers/authentication.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart'
    show UserPreferences;
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(FailedDeliveryAdapter());
  Hive.registerAdapter(SubAreaAdapter());
  Hive.registerAdapter(AreaAdapter());
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
        ChangeNotifierProvider(
          create: (_) => DeliveriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AreasProvider(),
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
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [
          BotToastNavigatorObserver()
        ], //2. registered route observer
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
