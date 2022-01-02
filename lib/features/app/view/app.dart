import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/features/app/view/loading_page.dart';
import 'package:jnb_mobile/features/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/features/delivery/bloc/delivery_cubit.dart';
import 'package:jnb_mobile/features/delivery/bloc/failed_deliver/failed_deliver_cubit.dart';
import 'package:jnb_mobile/features/delivery/bloc/update_location/update_location_cubit.dart';
import 'package:jnb_mobile/features/delivery/view/failed_deliveries_page.dart';
import 'package:jnb_mobile/features/delivery_filter/bloc/cubit/delivery_filter_cubit.dart';
import 'package:jnb_mobile/features/delivery_map/bloc/cubit/delivery_map_cubit.dart';
import 'package:jnb_mobile/features/home/view/home.dart';
import 'package:jnb_mobile/features/location/bloc/location_cubit.dart';
import 'package:jnb_mobile/features/login/bloc/login_cubit.dart';
import 'package:jnb_mobile/features/login/view/login_page.dart';
import 'package:jnb_mobile/features/delivery/view/deliver_page.dart';
import 'package:jnb_mobile/features/location/services/location_service.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/repositories/delivery_repository.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/utilities/betaTheme.dart';


class App extends StatelessWidget {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;
  final DeliveryRepository deliveryRepository;

  const App({
    @required this.authenticationRepository, 
    @required this.userRepository,
    @required this.deliveryRepository
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
            create: (context) => DeliveryCubit(
              deliveryRepository: deliveryRepository
          )),
          BlocProvider(
            create: (context) => UpdateLocationCubit(
              deliveryRepository: deliveryRepository, deliveryCubit: BlocProvider.of<DeliveryCubit>(context))
          ),
          BlocProvider(create: (context) => DeliveryFilterCubit()),
          BlocProvider(create: (context) => LocationCubit(
            locationService: LocationService()
          )),
          BlocProvider(create: (context) => DeliveryMapCubit(
            deliveryCubit: BlocProvider.of<DeliveryCubit>(context)
          ),
          ),
          BlocProvider(create: (context) => FailedDeliverCubit(
            deliveryRepository: deliveryRepository,
            deliveryCubit: BlocProvider.of<DeliveryCubit>(context)
            )
          )
        ],
        child: MaterialApp(
          title: 'JNatividadBilling',
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: AppThemes.beta(),
          routes: {
            '/': (context) => AppPage(),
            '/home': (context) => Home(),
            '/login': (context) => BlocProvider(
                  create: (context) => LoginCubit(
                    authenticationRepository: authenticationRepository,
                  ),
                  child: LoginPage(),
                ),
            '/delivery': (context) => DeliverPage(),
            '/deliveries/failed': (context) => FailedDeliveriesPage()
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
  AppPage({Key key}) : super(key: key);

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
          child: Container(color: Colors.white, child: LoadingPage()),
        ));
  }
}
