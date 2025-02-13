import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/user/user_edit.dart';
import 'package:mb_course/screens/user/user_payment_history.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import 'components/btm_delete_user.dart';
import 'user_course.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    // print('user id ${widget.userId}');
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchUserById(widget.userId));
    
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // print('selected user ${userProvider.selectedUser!.username}');
    // if (user == null) {
    //   return Center(child: Text("No user logged in"));
    // }

    return Scaffold(
      backgroundColor: backgroundColor,
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
          "User Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        centerTitle: true,
      ),
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading
          : userProvider.selectedUser == null
              ? Center(child: Text("User not found"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // User Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            userProvider.selectedUser!.avatar, // Fix: Load image from API
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userProvider.selectedUser!.username,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        _buildInformationSection(userProvider),
                        const SizedBox(height: 24),

                        // Action List Items
                        _buildActionItem(
                          icon: Icons.menu_book_outlined,
                          text: "My Courses",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserCourseListScreen()),
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
                              MaterialPageRoute(builder: (context) => UserCourseListScreen()),
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
                              MaterialPageRoute(builder: (context) => UserCourseListScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildActionItem(
                          icon: Icons.account_balance_wallet_outlined,
                          text: "My Purchases",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaymentHistoryScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildActionItem(
                          icon: Icons.account_balance_wallet_outlined,
                          text: "Billing Details",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaymentHistoryScreen()),
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
                                builder: (context) => UserInfoEditScreen(),
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

                        // Joined Date & Delete Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultTextWg(
                              text: "Joined Date: 24 Aug 2024",
                              fontColor: Colors.grey,
                            ),
                            BtmDeleteUser(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      
    );
}


  Widget _buildInformationSection(UserProvider userProvider) {
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
            _buildInfoRow('Username', userProvider.selectedUser!.username),
            const Divider(),
            _buildInfoRow('Fullname', userProvider.selectedUser!.username),
            const Divider(),
            _buildInfoRow('Email', userProvider.selectedUser!.email),
            const Divider(),
            _buildInfoRow('Contact', userProvider.selectedUser!.email),
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
      title: DefaultTextWg(text: text,),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}
