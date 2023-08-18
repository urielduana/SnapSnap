import 'dart:convert';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/services/dio.dart';
import 'package:snapsnap/models/user.dart';

class Auth extends ChangeNotifier {
  bool _isAuth = false;
  bool _authDenied = false;
  late User _user;
  late String? _token;

  bool get authenticated => _isAuth;
  bool get authDenied => _authDenied;
  User get user => _user;

  final storage = new FlutterSecureStorage();

  void login(Map credentials) async {
    // print(credentials);

    try {
      Dio.Response response =
          await dio().post('/sanctum/token', data: credentials);
      // print(response.data.toString());
      String token = response.data.toString();
      tryToken(token: token);
    } catch (e) {
      if (e is Dio.DioException) {
        if (e.response!.statusCode == 422) {
          print('Invalid credentials');
          _authDenied = true;
          notifyListeners();
        }
      }
    }
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        // print(response.data);
        _isAuth = true;
        _user = User.fromJson(response.data);
        _token = token;
        storeToken(token: token);
        storeUser(user: _user);
        notifyListeners();
        // print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
    // Clean secure storage token key if exists
    await storage.delete(key: 'token');
    storage.write(key: 'token', value: token);
  }

  void storeUser({required User user}) async {
    // Clean secure storage user key if exists
    await storage.delete(key: 'user');
    final userJson = jsonEncode(user);
    storage.write(key: 'user', value: userJson);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      // print(response.data);
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user.clear();
    _isAuth = false;
    _token = null;

    await storage.delete(key: 'token');
  }
}
