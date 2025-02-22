import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/cart_provider.dart';
import 'package:mb_course/providers/course_porvider.dart';
import 'package:mb_course/route/screen_export.dart';
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

  Future<void> initializeAuth() async {
    final token = await AuthHelper.getToken();
    if (token == null || token.isEmpty) {
      await AuthHelper.clearToken(); // Ensure no invalid tokens exist
    }
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

    try {
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201 && jsonResponse["status"] == "success") {
        return jsonResponse["status"];
      } else if (response.statusCode == 400 || response.statusCode == 409) {
      String errorMessage = "Registration failed. Please try again.";

      // Check if API returns an "errors" object with field-specific messages
      if (jsonResponse.containsKey("errors")) {
        List<String> messages = [];
        print('error ${jsonResponse["errors"]}');
        jsonResponse["errors"].forEach((key, value) {
          if (value is List) {
            messages.add(value.join(" ")); // Join multiple messages if any
          }
        });

        errorMessage = messages.join("\n"); // Show all error messages
      } 
      
      // Fallback to "message" if no specific errors found
      else if (jsonResponse.containsKey("message")) {
        errorMessage = jsonResponse["message"];
      }
      return errorMessage;
      }       
      else {
        return "An unexpected error occurred. Please try again later.";
      }
    } catch (e) {
      return "Error processing response. Please check your network.";
    }
  }

  // 🔹 Admin: Create New User
  Future<String?> createUser({
    required String username,
    required String email,
    required String role,
    String? phoneNumber,
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
        "phone_number": phoneNumber,
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

  Future<Map<String, dynamic>> updateUserDetails({
    required int userId,
    required Map<String, dynamic> updatedData,
    File? avatar,
  }) async {
    final url = Uri.parse(userUpdateUrl(userId));
    final token = await AuthHelper.getToken();
    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token';

    // Add form data
    updatedData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add image if available
    if (avatar != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return parsed JSON response
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    serverClientId: '230980647742-6v9bp4ovcp0s0bkqgnstgrl4o8juhgbe.apps.googleusercontent.com',
  );

  // Future<String?> signInWithGoogle() async {
  //   _setLoading(true);  // Start loading

  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       _setLoading(false);
  //       return "Google sign-in canceled";
  //     }

  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final String? idToken = googleAuth.idToken;

  //     if (idToken == null) {
  //       _setLoading(false);
  //       return "Failed to retrieve Google ID token";
  //     }

  //     // ✅ Send Google ID token to Django backend
  //     var url = Uri.parse(googleSiginUrl);
  //     var response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "id_token": idToken,  // Must match the backend expected key
  //       }),
  //     );

  //     _setLoading(false);  // Stop loading

  //     var jsonResponse = jsonDecode(response.body);

  //     if (response.statusCode == 200 && jsonResponse["status"] == "success") {
  //       _currentUser = UserModel.fromJson(jsonResponse["data"]);  // ✅ Parse response into UserModel    

  //       // ✅ Save tokens securely
  //       await AuthHelper.saveToken(_currentUser!.accessToken, _currentUser!.refreshToken);      
  //       notifyListeners();
  //       Future.delayed(Duration.zero, () {        
  //         Navigator.pushReplacement(
  //           _context!,
  //           MaterialPageRoute(builder: (_) => HomeScreen()),
  //     );
  //   });
  //       return jsonResponse["message"];  // ✅ Return success message
  //     } else {
  //       return jsonResponse["message"];  // ✅ Return error message from API
  //     }
  //   } catch (error) {
  //     _setLoading(false);
  //     return "An error occurred: $error";
  //   }
  // }

  Future<bool> signInWithGoogle() async {
  _setLoading(true);  // Start loading

  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      _setLoading(false);
      return false;  // Sign-in canceled
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      _setLoading(false);
      return false;  // Failed to get token
    }

    // ✅ Send Google ID token to Django backend
    var url = Uri.parse(googleSiginUrl);
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id_token": idToken,  // Must match backend expected key
      }),
    );

    _setLoading(false);  // Stop loading

    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse["status"] == "success") {
      _currentUser = UserModel.fromJson(jsonResponse["data"]);  // ✅ Parse response    

      // ✅ Save tokens securely
      await AuthHelper.saveToken(_currentUser!.accessToken, _currentUser!.refreshToken);      

      notifyListeners();
      return true;  // ✅ Return success
    } else {
      return false;  // ❌ Return failure
    }
  } catch (error) {
    _setLoading(false);
    return false;  // ❌ Return failure on error
  }
}



//   Future<void> signInWithGoogle(BuildContext context) async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google sign-in canceled')),
//       );
//       return;
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final String? idToken = googleAuth.idToken;

//     if (idToken == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to retrieve Google ID token')),
//       );
//       return;
//     }

//     // ✅ Send token to backend
//     final url = Uri.parse(googleSiginUrl);
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'id_token': idToken}),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);

//       // ✅ Save access & refresh tokens locally
//       final accessToken = responseData["data"]["access_token"];
//       final refreshToken = responseData["data"]["refresh_token"];

//       // Store the tokens securely (use shared_preferences or secure storage)
//       await SharedPreferences.getInstance().then((prefs) {
//         prefs.setString('access_token', accessToken);
//         prefs.setString('refresh_token', refreshToken);
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Signed in successfully')),
//       );
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => MainScreen()),
//         (Route<dynamic> route) => false,
//       );
//       // Navigate to home page or update UI
//     } else {
//       print('Error: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.body}')),
//       );
//     }
//   } catch (error) {
//     print('Error: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $error')),
//     );
//   }
// }

//   Future<void> signInWithGoogle(BuildContext context) async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google sign-in canceled')),
//       );
//       return;
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
//     // Force a fresh token
//     final String? idToken = googleAuth.idToken;
//     final String? accessToken = googleAuth.accessToken;

//     if (idToken == null || accessToken == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to retrieve Google ID token')),
//       );
//       return;
//     }

//     // ✅ Re-authenticate user to get a new token if necessary
//     final newAuth = await googleUser.authentication;
//     final String? freshIdToken = newAuth.idToken;

//     final url = Uri.parse(googleSiginUrl);
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'id_token': freshIdToken}),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Signed in successfully')),
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomeScreen()),
//       );
//     } else {
//       print('Error: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${response.body}')),
//       );
//     }
//   } catch (error) {
//     print('Error: $error');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('An error occurred: $error')),
//     );
//   }
// }



  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     // Trigger the Google Sign-In flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     print('google user $googleUser');
  //     if (googleUser == null) {
  //       // User cancelled the sign-in process
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Google sign-in canceled')),
  //       );
  //       return;
  //     }

  //     // Obtain the authentication details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final String? idToken = googleAuth.idToken;

  //     if (idToken == null) {
  //       print('idToken null ${googleAuth.idToken}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to retrieve Google ID token')),
  //       );
  //       return;
  //     }

  //     // Send the ID token to your Django backend for authentication
  //     final url = Uri.parse(googleSiginUrl);
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'access_token': idToken,  // Some setups expect 'access_token'
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // Successfully authenticated on the backend
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Signed in successfully')),
  //       );
  //       // Proceed to navigate or update your UI accordingly.
  //     } else {
  //       print('error ${response.body}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: ${response.body}')),
  //       );
  //     }
  //   } catch (error) {
  //     print('error $error');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: $error')),
  //     );
  //   }
  // }


  // 🔹 Login User
  Future<String?> loginUser({
    required String username,
    required String password,
  }) async {
    _setLoading(true);

    var url = Uri.parse(loginUrl);
    // print('username $username password $password');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    // print('response ${response.statusCode}');

    _setLoading(false);
    var jsonResponse = jsonDecode(response.body);
    // print('response data $jsonResponse');
    if (response.statusCode == 200 && jsonResponse["status"] == "success") {
      _currentUser = UserModel.fromJson(jsonResponse["data"]); // Parse response into UserModel    
      print('current user $_currentUser')  ;
      print('current user image ${_currentUser?.image}')  ;
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

  Future<void> fetchUserById(int userId) async {
    _setLoading(true);

    String? token = await AuthHelper.getToken();

    if (token == null) {
      _setLoading(false);
      return;
    }

    var url = Uri.parse(userProfileUrl(userId));
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
      notifyListeners();
    } else {
      print("Failed to load user details");
    }
  }

  Future<void> _handleSessionExpired() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('accessToken');
    // await prefs.remove('refreshToken');
    bool refreshed = await AuthHelper.refreshToken();
    if (refreshed) {
      print("Session refreshed successfully. Retrying request...");
      return; // Token refreshed, no need to log out
    }
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

  Future<void> forgotPassword(BuildContext context, String email) async {
  try {
    final url = Uri.parse(forgotPasswordUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      // PIN sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN sent to email')),
      );
    } else {
      // Handle API error responses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (error) {
    // Handle exceptions, such as network errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
}


Future<void> resetPassword(BuildContext context, String email, String pin, String newPassword) async {
  try {
    final url = Uri.parse(resetPasswordUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'pin': pin,
        'new_password': newPassword,
      }),
    );
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => UserLoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $error')),
    );
  }
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
    Provider.of<CourseProvider>(context, listen: false).clearCourses();
    
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
    // print("Retrieved token from storage: ${await _storage.read(key: 'accessToken')}");
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
    // print('check refresh token $refreshToken');
    if (refreshToken == null || refreshToken.isEmpty) {
      // add warning message session has expired
      await clearToken();
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