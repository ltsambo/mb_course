import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class ChangePasswordScreen extends StatefulWidget {    
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenWidgetState();
}

class _ChangePasswordScreenWidgetState extends State<ChangePasswordScreen> {
    
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // bool _obscureOldPassword = true;
  // bool _obscureNewPassword = true;
  // bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Back button action
        //   },
        // ),
        title: DefaultTextWg(text: "Change Password", fontSize:  24, fontWeight: FontWeight.bold,),        
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Email Field
            _buildTextField("Current Password", _oldPasswordController),
            const SizedBox(height: 16),
            // Current Password Field
            _buildTextField("New Password", _newPasswordController),
            const SizedBox(height: 16),
            // New Password Field
            _buildTextField("Confirm New Password", _confirmPasswordController),
            const SizedBox(height: 32),
            // Change Password Button
            ElevatedButton(
              onPressed: () async {
                if (_newPasswordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                  return;
                }

                PasswordChangeResponse response = await authProvider.changePassword(
                  oldPassword: _oldPasswordController.text,
                  newPassword: _newPasswordController.text,
                  confirmNewPassword: _confirmPasswordController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.message)),
                );

                if (response.status == "success") {
                  Navigator.pop(context); // Go back to previous screen
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Green button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Change Password",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: hint.contains("Password"), // Hide text for password fields
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
      ),
    );
  }
}
