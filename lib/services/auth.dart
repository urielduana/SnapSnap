import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:snapsnap/services/dio.dart';

class Auth extends ChangeNotifier {
  bool _isAuth = false;

  bool get authenticated => _isAuth;

  void login(Map credentials) async {
    print(credentials);

    Dio.Response response = await dio().post('sactum/token', data: credentials);
    print(response.data.toString());

    _isAuth = true;

    notifyListeners();
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
