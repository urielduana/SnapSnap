class User {
  String? name;
  String? email;
  String? avatar;
  String? username;
  String? phone;
  String? password;

  User({
    this.name,
    this.email,
    this.avatar,
    this.username,
    this.phone,
    this.password,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        username = json['username'],
        password = json['password'],
        phone = json['phone'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'username': username,
      'phone': phone,
      'password': password,
    };
  }

  clear() {
    name = null;
    email = null;
    avatar = null;
    username = null;
    phone = null;
    password = null;
  }
}
