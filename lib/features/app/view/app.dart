import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/features/app/view/loading_page.dart';
import 'package:jnb_mobile/features/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/features/home/view/home.dart';
import 'package:jnb_mobile/features/login/bloc/login_cubit.dart';
import 'package:jnb_mobile/features/login/view/login_page.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/modules/location/models/user_location_model.dart';
import 'package:jnb_mobile/modules/location/services/location_service.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import 'package:jnb_mobile/repositories/user_repository.dart';
import 'package:jnb_mobile/utilities/betaTheme.dart';
import 'package:provider/provider.dart';

// class App extends StatelessWidget {
//   final UserRepository userRepository;
//   final AuthenticationRepository authenticationRepository;

//   const App({
//     @required this.authenticationRepository,
//     @required this.userRepository
//   });

//   Future<User> getUserData() => UserPreferences().getUser();

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => AuthProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => UserProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => DeliveriesProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => AreasProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => DashboardProvider(),
//         ),
//         StreamProvider<UserLocation>(
//           create: (context) => LocationService().locationStream,
//         )
//       ],
//       child: MaterialApp(
//         title: 'JNatividadBilling',
//         routes: {
//           '/deliveries': (context) => Home(),
//           '/login': (context) => LoginPage()
//         },
//         builder: BotToastInit(), //1. call BotToastInit
//         navigatorObservers: [
//           BotToastNavigatorObserver()
//         ],
//         theme: AppThemes.beta(),
//         home: AppPage()
//         // FutureBuilder(
//         //   future: getUserData(),
//         //   builder: (context, snapshot) {
//         //     switch (snapshot.connectionState) {
//         //       case ConnectionState.none:
//         //       case ConnectionState.waiting:
//         //         return CircularProgressIndicator();
//         //       default:
//         //         if (snapshot.hasError)
//         //           return Text('Error: ${snapshot.error}');
//         //         else if (snapshot.data.id == null) return LoginPage();

//         //         return Home();
//         //     }
//         //   },
//         // ),
//       ),
//     );
//   }
// }

class App extends StatelessWidget {
  final UserRepository userRepository;
  final AuthenticationRepository authenticationRepository;

  const App(
      {@required this.authenticationRepository, @required this.userRepository});

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
                  create: (context) => LoginCubit(),
                  child: LoginPage(),
                )
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
