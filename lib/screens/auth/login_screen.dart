// screens/user_login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/main.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/screens/auth/register_screen.dart';
import 'package:mb_course/screens/user/user_forgot_password.dart';
import 'package:provider/provider.dart';
import '../../consts/consts.dart';
import '../../widgets/default_text.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {  

  // @override
  // void initState() {
  //   super.initState();
  //   final authProvider = Provider.of<UserProvider>(context, listen: false);
  //   authProvider.setContext(context); // Set context for navigation
  //   Future.microtask(() => authProvider.fetchUsers()); // Fetch users
  // }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  // Future<void> loginUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   var url = Uri.parse(loginUrl);
  //   var response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "username": _usernameController.text,
  //       "password": _passwordController.text,
  //     }),
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     String accessToken = data['access'];
  //     String refreshToken = data['refresh'];

  //     // Store the token
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('accessToken', accessToken);
  //     await prefs.setString('refreshToken', refreshToken);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Login Successful")),
  //     );

  //     // Navigate to Home Screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainScreen()),
  //     );
  //   } else {
  //     var error = jsonDecode(response.body);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error.toString())),
  //     );
  //   }
  // } 

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    logoImagePath, // Replace with your butterfly icon
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 8),
                  DefaultTextWg(
                    text: "Moe Yoga",
                    fontSize: 28,
                    fontColor: titleColor,
                  ),
                  const SizedBox(height: 8),
                  DefaultTextWg(
                    text: "Welcome Back",
                    fontSize: 16,
                    fontColor: blackColor,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter username' : null,
                    // onSaved: (value) => _username = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter password' : null,
                    // onSaved: (value) => _password = value,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(), 
                            ),
                          );
                      },
                      child: Text(
                        "Forgot Password",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  authProvider.isLoading 
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                      String? message = await authProvider.loginUser(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );

                      if (authProvider.user != null) {
                        // print('auth pro ${authProvider.user}');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message ?? "Login failed")),
                        );
                      }
                    },
                      child: DefaultTextWg(
                        text: "Login",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontColor: whiteColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultTextWg(text: "Don’t have an account yet?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(), 
                            ),
                          );
                        },
                        child: DefaultTextWg(
                          text: "Register",
                          fontColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
