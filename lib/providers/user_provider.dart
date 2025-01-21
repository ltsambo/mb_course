// providers/user_provider.dart
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool get isLoggedIn => _username != null;

  String? get username => _username;

  // Dummy user data
  final List<Map<String, String>> _dummyUsers = [
    {"username": "test", "password": "123"},
    {"username": "admin", "password": "123"},
    {"username": "user", "password": "123"},
  ];

  void login(String username, String password) {
    // Check if the username and password match any entry in dummy data
    final user = _dummyUsers.firstWhere(
      (user) => user["username"] == username && user["password"] == password,
      orElse: () => throw Exception('Invalid username or password'),
    );

    _username = user["username"];
    notifyListeners();
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}