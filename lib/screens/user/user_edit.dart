import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/models/user.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import 'components/btm_delete_user.dart';


class UserInfoEditScreen extends StatelessWidget {
  const UserInfoEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.currentUser;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: blackColor),
        //   onPressed: () {
        //     // Handle back navigation
        //   },
        // ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(        
        padding: const EdgeInsets.symmetric(horizontal: 16),        
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar with Edit Icon
            Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                      userData!.image, // Replace with user's avatar
                    ),
                  ),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width / 2 - 60,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {
                      // Handle avatar edit action
                    },
                    color: const Color(0xFF4A6057),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Editable Fields
            _buildEditableField(
              label: "Username",
              icon: Icons.person_outline,
              value: userData.username,
            ),
            const SizedBox(height: 16),            
            _buildEditableField(
              label: "Fullname",
              icon: Icons.card_membership_outlined,
              value: userData.name,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: "Email",
              icon: Icons.email_outlined,
              value: userData.email,
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: "Phone Number",
              icon: Icons.phone_outlined,
              value: userData.phone,
            ),
            const SizedBox(height: 32),
            // Confirm Button
            ElevatedButton(
              onPressed: () {
                // Handle confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6057), // Green button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Joined Date and Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultTextWg(text: "Joined Date: 24 Aug 2024", fontColor: Colors.grey,),                
                BtmDeleteUser(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          // controller: TextEditingController(text: value),
          decoration: InputDecoration(
            hintText: value,
            prefixIcon: Icon(icon, size: 18, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A6057)),
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
                
      ],
    );
  }
}
