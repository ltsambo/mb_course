import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/cart_provider.dart';
import 'package:mb_course/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../screens/auth/login_screen.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserProfileModel? _selectedUser;
  List<UserListModel> _userList = [];
  UserModel? get currentUser => _currentUser;
  bool _isLoading = false;
  BuildContext? _context;

  UserProfileModel? get selectedUser => _selectedUser;
  List<UserListModel> get users => _userList;
  UserModel? get user => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 🔹 Set context for navigation
  void setContext(BuildContext context) {
    _context = context;
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

  // 🔹 Admin: Create New User
  Future<String?> createUser({
    required String username,
    required String email,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      _setLoading(false);
      return "Admin not logged in";
    }

    var url = Uri.parse(adminUserCreateUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "role": role,
        "password": password,
        "confirm_password": confirmPassword,
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
    // print('response data $jsonResponse');
    if (response.statusCode == 200 && jsonResponse["status"] == "success") {
      _currentUser = UserModel.fromJson(jsonResponse["data"]); // Parse response into UserModel

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('accessToken', _currentUser!.accessToken);
      // await prefs.setString('refreshToken', _currentUser!.refreshToken);
      await AuthHelper.saveToken(_currentUser!.accessToken, _currentUser!.refreshToken);

      notifyListeners();
      return jsonResponse["message"];
    } else {
      return jsonResponse["message"];
    }
  }

  Future<void> fetchUsers() async {
    _setLoading(true);    
    String? token = await AuthHelper.getToken();

    if (token == null) {
      // _setLoading(false);
      _handleSessionExpired();
      return;
    }

    var url = Uri.parse(userListUrl);
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    _setLoading(false);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<UserListModel> fetchedUsers = (jsonResponse["data"] as List)
          .map((user) => UserListModel.fromJson(user))
          .toList();

      _userList = fetchedUsers;
      notifyListeners();
    } else if (response.statusCode == 401) {
      _handleSessionExpired(); // If session expired, logout and go to login screen
    } else {
      print("Failed to load users");
    }
  }

  // 🔹 Fetch User by ID
  Future<void> fetchUserById(int userId) async {
    _setLoading(true);

    String? token = await AuthHelper.getToken();

    if (token == null) {
      _setLoading(false);
      return;
    }

    var url = Uri.parse(userProfileUrl(userId));
    print('retrieve url $url/');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    _setLoading(false);

    // print('profile retrieve ${response.statusCode}');
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      _selectedUser = UserProfileModel.fromJson(jsonResponse["data"]);
      // print('selected user $_selectedUser');
      notifyListeners();
    } else {
      print("Failed to load user details");
    }
  }

  Future<void> _handleSessionExpired() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('accessToken');
    // await prefs.remove('refreshToken');
    await AuthHelper.clearToken();

    _currentUser = null;
    notifyListeners();

    if (_context != null) {
      Navigator.pushAndRemoveUntil(
        _context!,
        MaterialPageRoute(builder: (context) => UserLoginScreen()),
        (route) => false,
      );
    }
  }

  Future<PasswordChangeResponse> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _setLoading(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      _setLoading(false);
      return PasswordChangeResponse(
        status: "error",
        message: "User not logged in",
      );
    }

    var url = Uri.parse(changePasswordUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,  // Include confirm password
      }),
    );

    _setLoading(false);
    var jsonResponse = jsonDecode(response.body);

    return PasswordChangeResponse.fromJson(jsonResponse);
  }

  // 🔹 Logout User
  Future<void> logout(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('accessToken');
    // await prefs.remove('refreshToken');
    await AuthHelper.clearToken();

    _currentUser = null;
    _selectedUser = null;    
    _userList.clear();
    notifyListeners();

    Provider.of<CartProvider>(context, listen: false).clearLocalCart();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  }
}

class AuthHelper {
  static final _storage = FlutterSecureStorage();

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get stored access token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  // Store token securely
  static Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  // Clear stored tokens (logout)
  static Future<void> clearToken() async {
    await _storage.deleteAll();
  }

  static Future<bool> refreshToken() async {
    
    final refreshToken = await getRefreshToken();
    print('check refresh token $refreshToken');
    if (refreshToken == null) {
      // add warning message session has expired
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.navigateTo('/login');
      });
      return false;
    } 

    final url = Uri.parse(refreshTokenUrl); // Replace with actual refresh endpoint
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['access_token'], data['refresh_token']); // Store new tokens
      return true;
    } else {
      print('route to login ${response.statusCode}');
      await clearToken(); // Clear expired tokens
      NavigationService.navigateTo('/login'); // Redirect to login screen
      return false;
    }
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