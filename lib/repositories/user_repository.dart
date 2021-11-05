import 'dart:convert';

import 'package:http/http.dart';
import 'package:jnb_mobile/modules/authentication/models/user.dart';
import 'package:jnb_mobile/utilities/shared_preference.dart';
import 'package:jnb_mobile/utilities/urls.dart';

class UserRepository {
  User _user;

  Future<User> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = User(id: ""),
    );
  }

  Future<User> login(String username, String password) async{
    try{
      Response response = await post(
        AppUrls.loginURL,
        body: jsonEncode({
          'username': username,
          'password': password
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (!(response.statusCode == 200)) {
        throw Exception("Login Failed");
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final User user = User.fromJson(responseData['userData']);
      UserPreferences.saveUser(user);
      return user;
      
    } catch (err) {
      throw err;
    }
  }
}
