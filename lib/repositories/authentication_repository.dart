import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jnb_mobile/models/user_model.dart';
import 'package:jnb_mobile/services/user_service.dart';
import 'package:jnb_mobile/utilities/url_utility.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final Dio _dio = Dio();
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    final User user = await UserService.getUser();
    print(user);
    if(user.id != null){
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  // Future<void> logIn({@required String username,@required String password}) async {
  //   await Future.delayed(
  //     const Duration(milliseconds: 300),
  //     () => _controller.add(AuthenticationStatus.authenticated),
  //   );
  // }

  Future<void> login(String username, String password) async{
    try{
      Response response = await _dio.post(
        AppUrls.loginURL,
        data: jsonEncode({
          'username': username,
          'password': password
        }),
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
      );

      if (!(response.statusCode == 200)) {
        throw Exception(response.data['message']);
      }

      final Map<String, dynamic> responseData = response.data['data'];

      _controller.add(AuthenticationStatus.authenticated);

      final User user = User.fromJson(responseData);

      UserService.saveUser(user);
    } on DioError catch(err){
      print(err.toString());
      if (err.response != null){
        throw Exception(err.response!.data['message']);
      }
      throw Exception("System Error, please try again");
    } catch (err) {
      throw err;
    }
  }

  void logOut() {
    UserService.removeUser();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
