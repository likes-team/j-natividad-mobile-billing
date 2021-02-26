import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:jnb_mobile/modules/authentication/providers/authentication.dart';
import 'package:jnb_mobile/modules/authentication/models/user.dart' show User;
import 'package:jnb_mobile/modules/authentication/providers/user.dart';
import 'package:jnb_mobile/modules/authentication/components/widgets/login_widgets.dart';
import 'package:jnb_mobile/utilities/status.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) => value.isEmpty ? "Please enter username" : null,
      onSaved: (value) => _username = value,
      decoration: myInputDecorationWidget(
        "Username",
        Icons.email,
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value,
      decoration: myInputDecorationWidget("Password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (!(form.validate())) {
        Flushbar(
          title: "Failed Login!",
          message: "Please enter your username and password",
          duration: Duration(seconds: 3),
        ).show(context);
        return false;
      }

      form.save();

      final Future<Map<String, dynamic>> successfulMessage =
          auth.login(_username, _password);

      successfulMessage.then((response) {
        if (response['status']) {
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/deliveries');
        } else {
          Flushbar(
            title: "Failed Login!",
            message: response['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 250.0),
                  myLabelWidget("Email"),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 20.0),
                  myLabelWidget("Password"),
                  SizedBox(height: 5.0),
                  passwordField,
                  SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : myLongButtonWidget("Login", doLogin),
                  SizedBox(height: 5.0),
                ],
              ),
            )),
      )),
    );
  }
}
