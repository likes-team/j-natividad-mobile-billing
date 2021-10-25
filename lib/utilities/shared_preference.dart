import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/authentication/models/user.dart';

class UserPreferences {
  void saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userID', user.userID);
    prefs.setString('username', user.username);
    prefs.setString('fname', user.fname);
    prefs.setString('lname', user.lname);
    prefs.setString('email', user.email);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return User(
      userID: prefs.getString('userID'),
      username: prefs.getString('username'),
      fname: prefs.getString('fname'),
      lname: prefs.getString('name'),
      email: prefs.getString('email'),
      phone: prefs.getString('phone'),
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('UserID');
    prefs.remove('username');
    prefs.remove('fname');
    prefs.remove('lname');
    prefs.remove('email');
    prefs.remove('phone');
  }
}
