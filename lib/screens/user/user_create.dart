import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:provider/provider.dart';


class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final List<String> roles = ["student", "instructor", "admin"]; // Available roles
  String _selectedRole = "student"; // Default selected role

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Back button action
        //   },
        // ),
        title: Text(
          "Create User",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: Column(
          children: [
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
            // Role Dropdown
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  underline: const SizedBox(), // Remove underline
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  items: roles
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Select Image Button
            OutlinedButton(
              onPressed: () {
                // Add image selection functionality
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Colors.purple),
              ),
              child: Text(
                "Select Image",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            const Spacer(),
            // Create Button
            authProvider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      String? message = await authProvider.createUser(
                        username: _usernameController.text,
                        email: _emailController.text,
                        role: _selectedRole,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message ?? "User creation failed")),
                      );

                      if (message == "User created successfully") {
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Create",
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

  // Widget _buildTextField(String hint) {
  //   return TextField(
  //     decoration: InputDecoration(
  //       hintText: hint,
  //       hintStyle: GoogleFonts.poppins(
  //         fontSize: 14,
  //         color: Colors.grey,
  //       ),
  //       filled: true,
  //       fillColor: const Color(0xFFF0F4F8), // Light grey fill
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide.none,
  //       ),
  //     ),
  //   );
  // }

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
