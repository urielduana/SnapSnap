class User {
  String? name;
  String? email;
  String? avatar;
  String? username;
  String? phone;
  String? password;

  User({
    required this.name,
    required this.email,
    required this.avatar,
    required this.username,
    required this.phone,
    required this.password,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        username = json['username'],
        password = json['password'],
        phone = json['phone'];

  clear() {
    name = null;
    email = null;
    avatar = null;
    username = null;
    phone = null;
    password = null;
  }
}
