import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapsnap/main.dart';
import 'package:snapsnap/models/user.dart';
import 'package:snapsnap/screens/home_screen.dart';
import 'package:snapsnap/screens/register/register_password_screen.dart';
import 'package:snapsnap/screens/register/register_profilephoto_screen.dart';
import 'package:snapsnap/screens/register/register_username_screen.dart';

import 'dio.dart';

// Register class
class Register extends ChangeNotifier {
  var _user = User();
  bool _emailStatus = false;
  bool _usernameStatus = false;
  bool _passwordStatus = false;
  bool _selectedImage = false;
  late String? _token;

  User get user => _user;
  bool get emailStatus => _emailStatus;
  bool get usernameStatus => _usernameStatus;
  bool get passwordStatus => _passwordStatus;

  final storage = new FlutterSecureStorage();

  void verifyEmail(Map data, BuildContext context) async {
    try {
      Dio.Response response = await dio().post('/register/email', data: data);
      print(response.data.toString());
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

  void uploadAvatar(Map<String, dynamic> data, BuildContext context) async {
    try {
      Dio.FormData formData = Dio.FormData();
      formData.files.add(
          MapEntry('image', Dio.MultipartFile.fromFileSync(data['image'])));

      Dio.Response response = await dio().post('/img', data: formData);

      if (response.statusCode == 200) {
        _user = User();
        _user.avatar = response.data['avatar'];
        notifyListeners();
      } else {
        print('Error: ${response.statusCode}');
        print(response.data);
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void sendUserDataToApi(BuildContext context) async {
    try {
      // Send data to API
      Dio.Response response =
          await dio().post('/register', data: _user.toJson());
      if (response.statusCode == 200) {
        // print response
        print(response.toString());
        // Save token in secure storage
        _token = response.data.toString();
        print(_token);
        storeToken(token: _token!);
        print(storage.read(key: 'token'));
        notifyListeners();
        // Next screen to upload profile photo
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => MyApp()),
        // );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterProfilePhotoScreen()));
        // Return pop until to specific screen
        // Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Manejar el caso de un error en la respuesta de la API
        print('Error: ${response.statusCode}');
        print(response.data);
      }
    } catch (e) {
      // Manage exceptions in the request
      print('Exception: $e');
    }
  }

  void storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
  }
}
