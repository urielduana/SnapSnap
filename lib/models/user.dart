import 'package:snapsnap/models/collocation.dart';

class User {
  int? id;
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
    this.id,
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
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        username = json['username'],
        password = json['password'],
        phone = json['phone'],
        device_name = json['device_name'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    id = null;
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
