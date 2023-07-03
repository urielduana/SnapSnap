import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:snapsnap/models/user.dart';
import 'package:snapsnap/screens/register/register_username_screen.dart';

import 'dio.dart';

// Register class
class Register extends ChangeNotifier {
  late User _user;
  bool _emailStatus = false;

  User get user => _user;
  bool get emailStatus => _emailStatus;

  void verifyEmail(Map data, BuildContext context) async {
    try {
      Dio.Response response = await dio().post('/verifyEmail', data: data);
      print(response.data.toString());
      // Verify if response  is status 200 or 401
      if (response.statusCode == 200) {
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
}
