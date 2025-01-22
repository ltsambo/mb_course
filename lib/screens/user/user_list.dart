import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/screens/user/user_profile.dart';
import 'package:mb_course/widgets/default_text.dart';


class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        "name": "Admin",
        "role": "Admin",
        "email": "admin.moeyoga@gmail.com",
        "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
        "buttonColor": Colors.green,
      },
      {
        "name": "Cho May Ko",
        "role": "Cho May Ko",
        "email": "michiko8894@gmail.com",
        "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
        "buttonColor": Colors.orange,
      },
      {
        "name": "Moe Moe",
        "role": "Moe Moe",
        "email": "moemoe@gmail.com",
        "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
        "buttonColor": Colors.orange,
      },
      {
        "name": "Thazin",
        "role": "Thazin",
        "email": "thazinhnin1023@gmail.com",
        "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
        "buttonColor": Colors.green,
      },
      {
        "name": "Tin Zaw Win",
        "role": "Tin Zaw Win",
        "email": "tinzawwin@gmail.com",
        "image": "https://via.placeholder.com/150", // Replace with a URL or asset path
        "buttonColor": Colors.orange,
      },
    ];

    return Scaffold(
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
          "User List",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: blackColor),
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
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
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
                  backgroundImage: NetworkImage(user['image']),
                ),
                title: Text(
                  user['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextWg(text: user['role']),
                    DefaultTextWg(text: user['email'], fontColor: Colors.grey,),
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
                          builder: (context) => UserProfileScreen(),
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
