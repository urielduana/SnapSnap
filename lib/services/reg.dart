import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/main.dart';
import 'package:snapsnap/models/user.dart';
import 'package:snapsnap/screens/register/register_password_screen.dart';
import 'package:snapsnap/screens/register/register_profilephoto_screen.dart';
import 'package:snapsnap/screens/register/register_username_screen.dart';
import 'package:snapsnap/screens/tags/tag_select.dart';

import 'dio.dart';

// Register class
class Register extends ChangeNotifier {
  final _user = User();
  bool _emailStatus = false;
  bool _usernameStatus = false;
  bool _passwordStatus = false;
  String _token = '';
  User get user => _user;
  bool get emailStatus => _emailStatus;
  bool get usernameStatus => _usernameStatus;
  bool get passwordStatus => _passwordStatus;

  final storage = new FlutterSecureStorage();

  void verifyEmail(Map data, BuildContext context) async {
    try {
      Dio.Response response = await dio().post('/register/email', data: data);
      // print(response.data.toString());
      // Verify if response  is status 200 or 401
      if (response.statusCode == 200) {
        _user.email = data['email'];
        _user.device_name = data['device_name'];
        _emailStatus = false;
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterUsernameScreen()));
      } else {
        _emailStatus = true;
        notifyListeners();
      }
    } catch (e) {
      // print(e);
      _emailStatus = true;
      notifyListeners();
    }
  }

  void verifyUsername(Map data, BuildContext context) async {
    try {
      Dio.Response response =
          await dio().post('/register/username', data: data);
      // print(response.data.toString());
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
      // print(e);
      _usernameStatus = true;
      notifyListeners();
    }
  }

  void verifyPassword(Map data, BuildContext context) {
    if (data['password'] == data['confirmPassword']) {
      _user.password = data['password'];
      _passwordStatus = false;
      sendUserDataToApi(context);
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => const RegisterProfilePhotoScreen()));
      notifyListeners();
    } else {
      _passwordStatus = true;
      notifyListeners();
    }
  }

  void sendUserDataToApi(BuildContext context) async {
    try {
      // Send data to API
      Dio.Response response =
          await dio().post('/register', data: _user.toJson());
      if (response.statusCode == 200) {
        // print response
        // Save token in secure storage
        _token = response.data.toString();
        storeToken(token: _token);
        notifyListeners();
        // Next screen to upload profile photo
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => MyApp()),
        // );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterProfilePhotoScreen()));
      } else {
        // print(response.data);
      }
    } catch (e) {
      // Manage exceptions in the request
      // print('Exception: $e');
    }
  }

  void storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
    notifyListeners();
  }

  void uploadProfilePhoto(FormData formData, BuildContext context) async {
    _token = await storage.read(key: 'token') ?? '';

    try {
      Dio.Response response = await dio().post('/register/profile_photo',
          data: formData,
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TagSelectScreen()),
      );
    } catch (e) {
      // print(e);
    }
  }

  void uploadFavoriteTags(Map data, BuildContext context) async {
    _token = await storage.read(key: 'token') ?? '';
    // Extract the ids from each tag object and create a new list containing only the ids
    // Extract the ids from each tag object and create a new list containing only the ids
    List<int> tags = [];
    for (var i = 0; i < data['favorite_tags'].length; i++) {
      tags.add(data['favorite_tags'][i]['id']);
    }
    Map<String, dynamic> tagsData = {'favorite_tags': tags};
    try {
      Dio.Response response = await dio().post('/favorite_tags',
          data: tagsData,
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } catch (e) {
      print(e);
    }
  }
}
