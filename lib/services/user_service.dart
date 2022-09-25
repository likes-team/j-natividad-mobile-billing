import 'dart:async';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static void saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userID', user.id!);
    prefs.setString('username', user.username!);
    prefs.setString('fname', user.fname!);
    prefs.setString('lname', user.lname!);
    prefs.setString('email', user.email!);
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return User(
      id: prefs.getString('userID'),
      username: prefs.getString('username'),
      fname: prefs.getString('fname'),
      lname: prefs.getString('name'),
      email: prefs.getString('email'),
      phone: prefs.getString('phone'),
    );
  }

  static  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('userID');
    prefs.remove('username');
    prefs.remove('fname');
    prefs.remove('lname');
    prefs.remove('email');
    prefs.remove('phone');
  }
}
