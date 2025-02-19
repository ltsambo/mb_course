
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();

  // Future<void> registerUser() async {
  //   print('call function register');
  //   if (!_acceptTerms) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("You must accept the terms & conditions")),
  //     );
  //     return;
  //   }

  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Passwords do not match")),
  //     );
  //     return;
  //   }

  //   var url = Uri.parse(registerUrl);
  //   print('url $url');
  //   var response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "username": _usernameController.text,
  //       "email": _emailController.text,
  //       "password": _passwordController.text,
  //       "confirm_password": _confirmPasswordController.text,
  //       "role": "student",
  //       // "phone_number": _phoneController.text,
  //       // "address": _addressController.text
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Registration Successful"), backgroundColor: Colors.green,),
  //     );
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserLoginScreen()));
  //   } else {
  //     var error = jsonDecode(response.body);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error.toString())),
  //     );
  //   }
  // }
  // void _showToast(String message) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.values(20),
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: Colors.red,
  //     textColor: Colors.white,
  //   );
  // }
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Registration Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor, // Light beige background
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              DefaultTextWg(text: "Moe Yoga", fontSize: 24, fontColor: primaryColor,),
              const SizedBox(height: 8),
              DefaultTextWg(text: "Create an Account", fontSize: 18, fontColor: blackColor,),              
              const SizedBox(height: 24),
              // Name Field
              _buildTextField("Username", Icons.person, _usernameController, false),
              const SizedBox(height: 16),
              // Email Field
              _buildTextField("Email", Icons.email_outlined, _emailController, false),
              const SizedBox(height: 16),
              // Password Field
              _buildTextField("Password", Icons.lock_outline, _passwordController, true),
              const SizedBox(height: 16),
              // Confirm Password Field
              _buildTextField("Confirm Password", Icons.lock_outline, _confirmPasswordController, true),
              const SizedBox(height: 16),
              // Terms & Privacy Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  Expanded(
                    child: 
                    DefaultTextWg(text: "By continuing you accept our Privacy Policy and Term of Use", fontSize: 12, fontColor: blackColor,),                    
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Register Button
              authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                onPressed: () async {
                  String? message = await authProvider.registerUser(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    confirmPassword: _confirmPasswordController.text,
                    role: "student",
                    phoneNumber: '',
                    address: '',
                  );                  

                  if (message == "success") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Registration successful! Please login"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => UserLoginScreen()),
                    );                        
                  } else {
                    _showErrorDialog(context, message ?? "Registration failed");
                  }                      
                },                    
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Green button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: DefaultTextWg(text: "Register", fontColor: whiteColor,)
              ),
              const SizedBox(height: 16),
              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultTextWg(text: "Already have an account?", fontSize: 14, fontColor: blackColor,),                                      
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserLoginScreen(),
                        ),
                      );
                    },
                    child: DefaultTextWg(text: "Login",)
                  ),
                ],
              ),
            ],
          ),
        ),        
      ),      
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, bool isPassword) {
    
    return TextFormField(
      obscureText: isPassword && (hint == "Password"
          ? _obscurePassword
          : _obscureConfirmPassword),
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F4F8), // Light grey background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  hint == "Password"
                      ? (_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility)
                      : (_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    if (hint == "Password") {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }
}
