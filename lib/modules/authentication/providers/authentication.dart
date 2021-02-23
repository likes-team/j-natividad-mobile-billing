import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response, post;
import '../../../modules/authentication/models/user.dart';
import '../../../utilities/status.dart' show Status;
import '../../../utilities/urls.dart' show AppUrls;
import '../../../utilities/shared_preference.dart' show UserPreferences;

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;

  Status get loggedInStatus => _loggedInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    final Map<String, String> loginData = {
      'username': username,
      'password': password,
    };

    _loggedInStatus = Status.Authenticating;

    notifyListeners();

    Response response = await post(
      AppUrls.loginURL,
      body: jsonEncode(loginData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (!(response.statusCode == 200)) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "Login Failed"};
      return result;
    }

    final Map<String, dynamic> responseData = json.decode(response.body);

    var userData = responseData['userData'];

    User authUser = User.fromJson(userData);

    UserPreferences().saveUser(authUser);

    _loggedInStatus = Status.LoggedIn;

    result = {'status': true, 'message': 'Successfull', 'user': authUser};

    return result;
  }
}
