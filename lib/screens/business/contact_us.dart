import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/default_text.dart';


class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Handle back navigation
        //   },
        // ),
        title: DefaultTextWg(text: "Contact Us", fontSize: 24,),        
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // Logo
          Center(
            child: Column(
              children: [
                Image.network(
                  "https://static.vecteezy.com/system/resources/previews/012/880/017/large_2x/comfortable-apartment-with-bright-and-cozy-interior-design-free-photo.jpg", // Replace with logo URL or asset
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                DefaultTextWg(text: "Test ", fontSize: 20, fontWeight: FontWeight.bold, fontColor: primaryColor,),                
                const SizedBox(height: 8),
                Text(
                  "test@gmail.com",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // List Items
          _buildListItem(
            context,
            icon: Icons.phone_outlined,
            text: "+95912345",
            onTap: () {
              // Handle phone tap
            },
          ),
          const Divider(),
          _buildListItem(
            context,
            icon: Icons.location_on_outlined,
            text: "Address",
            onTap: () {
              // Handle address tap
            },
          ),
          const Divider(),
          // Something Item
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[100],
              child: const Icon(Icons.refresh, color: Colors.red),
            ),
            title: Text(
              "Something",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            onTap: () {
              // Handle something tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange[100],
        child: Icon(icon, color: Colors.orange),
      ),
      title: DefaultTextWg(text: text),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
      onTap: onTap,
    );
  }
}
