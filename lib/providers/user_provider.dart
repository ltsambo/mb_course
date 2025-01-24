// providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:mb_course/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;
  // String? _username;
  // bool get isLoggedIn => _username != null;

  // String? get username => _username;

  // Dummy user data
  final List<User> _dummyUsers = [
      User(
        image:
            "assets/user_avatar.png",
        name: 'Test Test',
        username: 'test',
        password: '123',
        email: 'test.test@gmail.com',
        phone: '(208) 206-5039',
        aboutMeDescription:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
      ),
      User(
        image:
            "assets/user_avatar.png",
        name: 'Test User',
        username: 'testuser1',
        password: '123',
        email: 'test.user1@gmail.com',
        phone: '(208) 206-1234',
        aboutMeDescription:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
      ),
      User(
        image:
            "https://v3-ltsambo-bucket.s3.us-west-2.amazonaws.com/static/images/favicon.svg",
        name: 'Test User2',
        username: 'testuser2',
        password: '123',
        email: 'test.user2@gmail.com',
        phone: '(208) 206-5678',
        aboutMeDescription:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
      ),
      User(
        image:
            "https://v3-ltsambo-bucket.s3.us-west-2.amazonaws.com/static/images/favicon.svg",
        name: 'Test User3',
        username: 'testuser3',
        password: '123',
        email: 'test.user3@gmail.com',
        phone: '(208) 206-1039',
        aboutMeDescription:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
      ),
  ];

  void login(String username, String password) {
    // Check if the username and password match any entry in dummy data
    final user = _dummyUsers.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => throw Exception('Invalid username or password'),
    );

    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateProfile(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}