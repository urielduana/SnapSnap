import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:snapsnap/models/user.dart';
import 'package:snapsnap/screens/register/register_password_screen.dart';
import 'package:snapsnap/screens/register/register_username_screen.dart';

import 'dio.dart';

// Register class
class Register extends ChangeNotifier {
  var _user = User();
  bool _emailStatus = false;
  bool _usernameStatus = false;
  bool _passwordStatus = false;

  User get user => _user;
  bool get emailStatus => _emailStatus;
  bool get usernameStatus => _usernameStatus;
  bool get passwordStatus => _passwordStatus;

  void verifyEmail(Map data, BuildContext context) async {
    try {
      Dio.Response response = await dio().post('/register/email', data: data);
      print(response.data.toString());
      // Verify if response  is status 200 or 401
      if (response.statusCode == 200) {
        _user.email = data['email'];
        _emailStatus = false;
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterUsernameScreen()));
      } else {
        _emailStatus = true;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      _emailStatus = true;
      notifyListeners();
    }
  }

  void verifyUsername(Map data, BuildContext context) async {
    try {
      Dio.Response response =
          await dio().post('/register/username', data: data);
      print(response.data.toString());
      // Verify if response  is status 200 or 401
      if (response.statusCode == 200) {
        _user.username = data['username'];
        _usernameStatus = false;
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterPasswordScreen()));
      } else {
        _usernameStatus = true;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      _usernameStatus = true;
      notifyListeners();
    }
  }

  void passwordVerify(Map data) {
    if (data['password'] == data['confirmPassword']) {
      _user.password = data['password'];
      _passwordStatus = false;
      notifyListeners();
    } else {
      _passwordStatus = true;
      notifyListeners();
    }
  }
}
