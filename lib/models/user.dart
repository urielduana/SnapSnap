class User {
  String name;
  String email;
  String avatar;
  String username;
  String phone;

  User(
      {required this.name,
      required this.email,
      required this.avatar,
      required this.username,
      required this.phone});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        username = json['username'],
        phone = json['phone'];
}
