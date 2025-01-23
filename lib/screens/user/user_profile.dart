import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/user/user_edit.dart';
import 'package:mb_course/screens/user/user_payment_history.dart';
import 'package:mb_course/widgets/default_text.dart';

import '../../models/user.dart';
import 'components/btm_delete_user.dart';
import 'user_course.dart';


class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    User _userData = UserData.myUser;
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
        title: Text(
          "User Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // User Avatar and Info
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                _userData.image, // Replace with user image URL or asset path
              ),
            ),
            const SizedBox(height: 16),
            // Text(
            //   "Admin",
            //   style: GoogleFonts.poppins(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),            
            const SizedBox(height: 24),
            _buildInformationSection(_userData),
            
            const SizedBox(height: 24),
            
            // Action List Items
            _buildActionItem(
              icon: Icons.menu_book_outlined,
              text: "My Courses",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => UserCourseListScreen())
                );
              },
            ),
            const Divider(height: 1),
            _buildActionItem(
              icon: Icons.add_shopping_cart,
              text: "My Cart",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => UserCourseListScreen())
                );
              },
            ),
            const Divider(height: 1),
            _buildActionItem(
              icon: Icons.favorite_sharp,
              text: "Wishlist",
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => UserCourseListScreen())
                );
              },
            ),
            const Divider(height: 1),
            _buildActionItem(
              icon: Icons.account_balance_wallet_outlined,
              text: "Billing Details",
              onTap: () {                
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => PaymentHistoryScreen())
                );
              },
            ),
            const Divider(height: 1),
            const SizedBox(height: 24),  
              // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoEditScreen(), // Replace with your Page Settings screen
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A6057),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Edit Profile",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _buildInformationSection(User userData) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Username', userData.username),
            const Divider(),
            _buildInfoRow('Fullname', userData.name),
            const Divider(),
            _buildInfoRow('Email', userData.email),
            const Divider(),
            _buildInfoRow('Contact', userData.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}
