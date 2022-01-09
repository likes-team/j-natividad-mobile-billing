import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jnb_mobile/features/about/view/about.dart';
import 'package:jnb_mobile/features/authentication/bloc/authentication_bloc.dart';
import 'package:jnb_mobile/repositories/authentication_repository.dart';
import '../../../../utilities/colors.dart' show AppColors;

class DrawerComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/image/logo.png'),
              height: 20,
            ),
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text('For Upload Deliveries'),
            onTap: () {
              Navigator.pushNamed(context, '/deliveries/failed');
            },
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 15,
            endIndent: 50,
            color: Colors.black,
          ),
          // ListTile(
          //   leading: Icon(Icons.favorite),
          //   title: const Text('Favorite'),
          //   onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          // const Divider(
          //         height: 1,
          //         thickness: 1,
          //          indent:15,
          //         endIndent: 50,
          //         color: Colors.black,
          //       ),
          ListTile(
            leading: Icon(Icons.info_rounded),
            title: const Text('About'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),

          const Divider(
            height: 1,
            thickness: 1,
            indent: 15,
            endIndent: 50,
            color: Colors.black,
          ),

          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(Icons.logout),
                title: state.status == AuthenticationStatus.authenticated
                    ? Text('Logout')
                    : Text('Logging out, please wait...'),
                onTap: () async {
                  final authenticationBloc = context.read<AuthenticationBloc>();
                  authenticationBloc.add(AuthenticationLogoutRequested());
                  // to login page
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
