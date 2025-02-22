import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/cart/cart_screen.dart';
import 'package:mb_course/screens/order/order_screen.dart';
import 'package:mb_course/screens/user/user_edit.dart';
import 'package:mb_course/screens/user/user_payment_history.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
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
    print('user id ${widget.userId}');
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchUserById(widget.userId));
    
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // if (user == null) {
    //   return Center(child: Text("No user logged in"));
    // }
    final imageUrl = (userProvider.selectedUser != null && 
                    userProvider.selectedUser!.avatar != null &&
                    userProvider.selectedUser!.avatar!.isNotEmpty)
      ? userProvider.selectedUser!.avatar!
      : '';
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: DefaultTextWg(text: 'User Profile', fontSize: 24, fontColor: whiteColor,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: whiteColor,),
          onPressed: () {
            Navigator.pop(context);
          },
        ), 
        centerTitle: false,
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
                          backgroundImage:  userProvider.selectedUser!.avatar.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : AssetImage(noUserImagePath) as ImageProvider,                               
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
                              MaterialPageRoute(builder: (context) => CartScreen()),
                            );
                          },
                        ),
                        // const Divider(height: 1),
                        // _buildActionItem(
                        //   icon: Icons.favorite_sharp,
                        //   text: "Wishlist",
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => UserCourseListScreen()),
                        //     );
                        //   },
                        // ),
                        const Divider(height: 1),
                        _buildActionItem(
                          icon: Icons.account_balance_wallet_outlined,
                          text: "My Purchases",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => OrderListScreen()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        // _buildActionItem(
                        //   icon: Icons.account_balance_wallet_outlined,
                        //   text: "Billing Details",
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => PaymentHistoryScreen()),
                        //     );
                        //   },
                        // ),
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
                          child: DefaultTextWg(text: "Edit Profile", fontColor: whiteColor,) 
                        ),
                        const SizedBox(height: 16),

                        // CustomDeleteBtm(
                        //   fct: ()=> {}, 
                        //   lastDate: GlobalMethods.formatDate(userProvider.selectedUser!.createdOn.toString())),
                        // Joined Date & Delete Button                        
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
            // const Divider(),
            // _buildInfoRow('Fullname', userProvider.selectedUser!.username),
            const Divider(),
            _buildInfoRow('Email', userProvider.selectedUser!.email),
            const Divider(),
            _buildInfoRow('Contact', userProvider.selectedUser!.phoneNumber ?? '-'),
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
