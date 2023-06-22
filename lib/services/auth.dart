import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:snapsnap/models/user.dart';

class Auth extends ChangeNotifier {
  bool _isAuth = false;
  late User _user;
  late String _token;

  bool get authenticated => _isAuth;
  User get user => _user;

  void login(Map credentials) async {
    // print(credentials);

    try {
      Dio.Response response =
          await dio().post('sactum/token', data: credentials);
      // print(response.data.toString());
      String token = response.data.toString();
      tryToken(token: token);
      _isAuth = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _isAuth = true;
        _user = User.fromJson(response.data);
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
