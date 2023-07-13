import 'package:snapsnap/models/collocation.dart';

class User {
  String? name;
  String? email;
  String? avatar;
  String? username;
  String? phone;
  String? password;
  String? device_name;
  int? followers;
  int? following;
  late List<Collocation> collocation;

  User({
    this.name,
    this.email,
    this.avatar,
    this.username,
    this.phone,
    this.password,
    this.collocation = const [],
    this.followers,
    this.following,
    this.device_name,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        username = json['username'],
        password = json['password'],
        phone = json['phone'],
        device_name = json['device_name'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'username': username,
      'phone': phone,
      'password': password,
      'device_name': device_name,
    };
  }

  clear() {
    name = null;
    email = null;
    avatar = null;
    username = null;
    phone = null;
    password = null;
    collocation = [];
    followers = null;
    following = null;
    device_name = null;
  }
}
