import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:snapsnap/models/user.dart';
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
      print(_user.toJson()); // Imprimir los datos antes de enviarlos a la API
      Dio.Response response =
          await dio().post('/register', data: _user.toJson());
      if (response.statusCode == 200) {
        //imprimir response
        print(response.toString());
        // Procesar la respuesta o realizar alguna acción adicional si es necesario
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterProfilePhotoScreen()));
      } else {
        // Manejar el caso de un error en la respuesta de la API
        print('Error: ${response.statusCode}');
        print(response.data);
      }
    } catch (e) {
      // Manejar cualquier excepción que ocurra durante la solicitud
      print('Exception: $e');
    }
  }
}
