import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String image;
  String email;
  final String username;
  final String password;
  String phone;
  final String? address;
  String aboutMeDescription;

  User({
    required this.name,
    required this.image,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    this.address,
    required this.aboutMeDescription,
  });

  User copy({
    String? imagePath,
    String? name,
    String? username,
    String? password,
    String? phone,
    String? email,
    String? about,
  }) =>
      User(
        image: imagePath ?? this.image,
        username: username ?? this.username,
        password: password ?? this.password,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        aboutMeDescription: about ?? this.aboutMeDescription,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        image: json['imagePath'],
        username: json['username'],
        password: json['password'],
        name: json['name'],
        email: json['email'],
        aboutMeDescription: json['about'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'username': username,
        'password': password,
        'name': name,
        'email': email,
        'about': aboutMeDescription,
        'phone': phone,
      };
}

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    image:
        "https://cdn.vectorstock.com/i/2000v/31/95/user-sign-icon-person-symbol-human-avatar-vector-12693195.avif",
    name: 'Test Test',
    username: 'test',
    password: '123',
    email: 'test.test@gmail.com',
    phone: '(208) 206-5039',
    aboutMeDescription:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}