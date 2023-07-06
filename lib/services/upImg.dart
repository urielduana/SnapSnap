import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snapsnap/models/user.dart';

import 'dio.dart';

class UpImg extends ChangeNotifier {
  late User _user;

  User get user => _user;

  void uploadAvatar(Map<String, dynamic> data, BuildContext context) async {
    try {
      FormData formData = FormData();
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(data['image'])));

      Response response = await dio().post('/img', data: formData);

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
}
