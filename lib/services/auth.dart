import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  bool _isAuth = false;

  bool get authenticated => _isAuth;

  void login(Map creds) {
    _isAuth = true;
    notifyListeners();
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
