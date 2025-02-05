import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';


class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print("user provider ${userProvider.users.length}");
    return Scaffold(
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
          "User List",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: whiteColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserScreen(),
                ),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userProvider.users.length,
              itemBuilder: (context, index) {
                final UserListModel user = userProvider.users[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(user.image),
                      ),
                      title: Text(
                        user.username,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.role, style: TextStyle(color: Colors.black)),
                          Text(user.email, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward, color: whiteColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(userId: user.id,),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// class UserListScreen extends StatelessWidget {
//   const UserListScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> users = [
//       {
//         "name": "Admin",
//         "role": "Admin",
//         "email": "admin.moeyoga@gmail.com",
//         "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
//         "buttonColor": Colors.green,
//       },
//       {
//         "name": "Cho May Ko",
//         "role": "Cho May Ko",
//         "email": "michiko8894@gmail.com",
//         "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
//         "buttonColor": Colors.orange,
//       },
//       {
//         "name": "Moe Moe",
//         "role": "Moe Moe",
//         "email": "moemoe@gmail.com",
//         "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
//         "buttonColor": Colors.orange,
//       },
//       {
//         "name": "Thazin",
//         "role": "Thazin",
//         "email": "thazinhnin1023@gmail.com",
//         "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
//         "buttonColor": Colors.green,
//       },
//       {
//         "name": "Tin Zaw Win",
//         "role": "Tin Zaw Win",
//         "email": "tinzawwin@gmail.com",
//         "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
//         "buttonColor": Colors.orange,
//       },
//     ];

    
//   }
// }
