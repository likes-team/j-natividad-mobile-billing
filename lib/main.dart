import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jnb_mobile/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/blocs/deliver/deliver_cubit.dart';
import 'package:jnb_mobile/blocs/deliveries/delivery_cubit.dart';
import 'package:jnb_mobile/blocs/deliveries_filter/delivery_filter_cubit.dart';
import 'package:jnb_mobile/blocs/failed_deliver/failed_deliver_cubit.dart';
import 'package:jnb_mobile/blocs/location/location_cubit.dart';
import 'package:jnb_mobile/blocs/login/login_cubit.dart';
import 'package:jnb_mobile/blocs/map/delivery_map_cubit.dart';
import 'package:jnb_mobile/blocs/update_location/update_location_cubit.dart';
import 'package:jnb_mobile/global_variables.dart';
import 'package:jnb_mobile/models/areas.dart';
import 'package:jnb_mobile/models/delivery.dart';
import 'package:jnb_mobile/models/failed_delivery.dart';
import 'package:jnb_mobile/models/sub_areas.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/pages/deliver_page.dart';
import 'package:jnb_mobile/pages/failed_deliveries_page.dart';
import 'package:jnb_mobile/pages/home_page.dart';
import 'package:jnb_mobile/pages/login_page.dart';
import 'package:jnb_mobile/pages/profile_page.dart';
import 'package:jnb_mobile/pages/splash_page.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/services/location_service.dart';
import 'package:jnb_mobile/services/user_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DeliveryAdapter());
  Hive.registerAdapter(FailedDeliveryAdapter());
  Hive.registerAdapter(SubAreaAdapter());
  Hive.registerAdapter(AreaAdapter());
  // await connectToDB();

  await Hive.openBox<FailedDelivery>(globalFailedDeliveriesBoxName);
  await Hive.openBox<Delivery>(globalDeliveriesBoxName);

  globalAppImagesDirectory = await _createFolder();

  await Geolocator.requestPermission();

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    deliveryRepository: DeliveryRepository(),
  ));
}

// Future<void> connectToDB() async {
//   globalMongoDB = await mongo.Db.create("mongodb+srv://dbUser:dbUserPassword@cluster0.jjlnnvp.mongodb.net/upecDevDB?retryWrites=true&w=majority&ssl=true");
//   await globalMongoDB!.open();
// }

Future<Directory> _createFolder() async {
  const folderName = "jnatividaddelivery";
  Directory? appDocumentsDirectory = await (getExternalStorageDirectory()); // 1
  final appDocumentsPath = Directory("${appDocumentsDirectory?.path}/$folderName"); // 2
  print(appDocumentsPath.path);
  // final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    await Permission.storage.request();
  }

  if ((await appDocumentsPath.exists())) {
    return appDocumentsPath;
  } else {
    appDocumentsPath.create();
    return appDocumentsPath;
  }
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  final DeliveryRepository deliveryRepository;

  const App({super.key, 
    required this.authenticationRepository, 
    required this.userRepository,
    required this.deliveryRepository
  });

  // Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: userRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
                authenticationRepository: authenticationRepository,
                userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) => DeliveriesCubit(
              deliveryRepository: deliveryRepository
          )),
          BlocProvider(
            create: (context) => UpdateLocationCubit(
              deliveryRepository: deliveryRepository, deliveryCubit: BlocProvider.of<DeliveriesCubit>(context))
          ),
          BlocProvider(create: (context) => DeliveryFilterCubit()),
          BlocProvider(create: (context) => LocationCubit(
            locationService: LocationService()
          )),
          BlocProvider(create: (context) => DeliveryMapCubit(
            deliveryCubit: BlocProvider.of<DeliveriesCubit>(context)
          ),
          ),
          BlocProvider(create: (context) => FailedDeliverCubit(
            deliveryRepository: deliveryRepository,
            deliveryCubit: BlocProvider.of<DeliveriesCubit>(context)
            )
          ),
          BlocProvider(create: (context) => DeliverCubit(
            deliveryRepository: deliveryRepository,
            deliveryCubit: BlocProvider.of<DeliveriesCubit>(context)
            )
          )
        ],
        child: MaterialApp(
          title: 'JNatividadBilling',
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),          routes: {
            '/': (context) => AppPage(),
            '/home': (context) => const HomePage(),
            '/login': (context) => BlocProvider(
                  create: (context) => LoginCubit(
                    authenticationRepository: authenticationRepository,
                  ),
                  child: LoginPage(),
                ),
            '/delivery': (context) => DeliverPage(),
            '/deliveries/failed': (context) => FailedDeliveriesPage(),
            '/reports': (context) => ProfilePage()
          },
          // FutureBuilder(
          //   future: getUserData(),
          //   builder: (context, snapshot) {
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.none:
          //       case ConnectionState.waiting:
          //         return CircularProgressIndicator();
          //       default:
          //         if (snapshot.hasError)
          //           return Text('Error: ${snapshot.error}');
          //         else if (snapshot.data.id == null) return LoginPage();

          //         return Home();
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() { 
    super.initState();
    
    // Get user location
    BlocProvider.of<LocationCubit>(context).getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) {
            return previous != current;
          },
          listener: (context, state) {
            if (state.status == AuthenticationStatus.unauthenticated) {
              Navigator.pushNamed(context, '/login');
            } else if (state.status == AuthenticationStatus.authenticated) {
              Navigator.pushNamed(context, '/home');
            }
          },
          child: Container(color: Colors.white, child: const SplashPage()),
        ));
  }
}
