import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mb_course/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool _isLoading = false;

  UserModel? get user => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 🔹 Register User
  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    required String phoneNumber,
    required String address,    
  }) async {
    _setLoading(true);

    var url = Uri.parse(registerUrl);
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        "role": role,
        "phone_number": phoneNumber,
        "address": address,
      }),
    );

    _setLoading(false);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 201 && jsonResponse["status"] == "success") {
      return jsonResponse["message"];
    } else {
      return jsonResponse["message"];
    }
  }

  // 🔹 Login User
  Future<String?> loginUser({
    required String username,
    required String password,
  }) async {
    _setLoading(true);

    var url = Uri.parse(loginUrl);
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    _setLoading(false);
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse["status"] == "success") {
      _currentUser = UserModel.fromJson(jsonResponse["data"]); // Parse response into UserModel

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', _currentUser!.accessToken);
      await prefs.setString('refreshToken', _currentUser!.refreshToken);

      notifyListeners();
      return jsonResponse["message"];
    } else {
      return jsonResponse["message"];
    }
  }

  // 🔹 Logout User
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    _currentUser = null;
    notifyListeners();
  }
}


// class UserProvider extends ChangeNotifier {
//   User? _currentUser;

//   User? get currentUser => _currentUser;

//   bool get isAuthenticated => _currentUser != null;
//   // String? _username;
//   // bool get isLoggedIn => _username != null;

//   // String? get username => _username;

//   // Dummy user data
//   final List<User> _dummyUsers = [
//       User(
//         image:
//             "assets/user_avatar.png",
//         name: 'Test Test',
//         username: 'test',
//         password: '123',
//         email: 'test.test@gmail.com',
//         phone: '(208) 206-5039',
//         aboutMeDescription:
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//       ),
//       User(
//         image:
//             "assets/user_avatar.png",
//         name: 'Test User',
//         username: 'testuser1',
//         password: '123',
//         email: 'test.user1@gmail.com',
//         phone: '(208) 206-1234',
//         aboutMeDescription:
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//       ),
//       User(
//         image:
//             "https://v3-ltsambo-bucket.s3.us-west-2.amazonaws.com/static/images/favicon.svg",
//         name: 'Test User2',
//         username: 'testuser2',
//         password: '123',
//         email: 'test.user2@gmail.com',
//         phone: '(208) 206-5678',
//         aboutMeDescription:
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//       ),
//       User(
//         image:
//             "https://v3-ltsambo-bucket.s3.us-west-2.amazonaws.com/static/images/favicon.svg",
//         name: 'Test User3',
//         username: 'testuser3',
//         password: '123',
//         email: 'test.user3@gmail.com',
//         phone: '(208) 206-1039',
//         aboutMeDescription:
//             'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//       ),
//   ];

//   void login(String username, String password) {
//     // Check if the username and password match any entry in dummy data
//     final user = _dummyUsers.firstWhere(
//       (user) => user.username == username && user.password == password,
//       orElse: () => throw Exception('Invalid username or password'),
//     );

//     _currentUser = user;
//     notifyListeners();
//   }

//   void logout() {
//     _currentUser = null;
//     notifyListeners();
//   }

//   void updateProfile(User updatedUser) {
//     _currentUser = updatedUser;
//     notifyListeners();
//   }
// }