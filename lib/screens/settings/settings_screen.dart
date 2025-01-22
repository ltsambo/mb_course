import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mb_course/route/route_constants.dart';
import 'package:mb_course/route/router.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/management/management_screen.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import '../../route/screen_export.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/display_image_widget.dart';
import '../user/edit_description.dart';
import '../user/edit_email.dart';
import '../user/edit_image.dart';
import '../user/edit_name.dart';
import '../user/edit_phone.dart';
import 'package:mb_course/route/screen_export.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: DefaultTextWg(text: 'Setting', fontSize: 24,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            // Management Section
            _buildSectionCard(
              title: "Management",
              children: [
                _buildListItem(
                  icon: Icons.account_circle_outlined,
                  text: "Admin Management Panel",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagementItemsScreen(),
                      ),
                    );
                    // Navigator.pushNamed(context, managementScreenRoute);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // My Information Section
            _buildSectionCard(
              title: "My Information",
              children: [
                _buildListItem(
                  icon: Icons.person_outline,
                  text: "Profile",
                  onTap: () {
                    // Add functionality
                  },
                ),
                _buildListItem(
                  icon: Icons.lock_outline,
                  text: "Change Password",
                  onTap: () {
                    // Add functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Security Section
            _buildSectionCard(
              title: "Security",
              children: [
                _buildToggleItem(
                  icon: Icons.shield_outlined,
                  text: "Biometrics",
                  value: false,
                  onChanged: (value) {
                    // Handle toggle
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Other Section
            _buildSectionCard(
              title: "Other",
              children: [
                _buildListItem(
                  icon: Icons.mail_outline,
                  text: "Contact Us",
                  onTap: () {
                    // Add functionality
                  },
                ),
                _buildListItem(
                  icon: Icons.privacy_tip_outlined,
                  text: "Privacy Policy",
                  onTap: () {
                    // Add functionality
                  },
                ),
                _buildListItem(
                  icon: Icons.logout,
                  text: "Logout",
                  onTap: () {
                    // Add functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: const Color(0xFFF8EFE4),
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.self_improvement),
      //       label: "Yoga",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: "Setting",
      //     ),
      //   ],
      //   selectedItemColor: const Color(0xFF4A6057),
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 2, // Setting is selected
      //   onTap: (index) {
      //     // Handle navigation
      //   },
      // ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextWg(text: title, fontSize: 16,),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A6057)),
      title: DefaultTextWg(text: text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4A6057)),
      title: DefaultTextWg(text: text),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4A6057),
      ),
    );
  }
}

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = UserData.myUser;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               toolbarHeight: 10,
//             ),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Text(
//                   'Edit Profile',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w700,
//                     color: Color.fromRGBO(64, 105, 225, 1),
//                   ),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 navigateSecondPage(EditImagePage());
//               },
//               child: DisplayImage(
//                 imagePath: user.image,
//                 onPressed: () {},
//               ),
//             ),
//             buildUserInfoDisplay(
//               user.name,
//               'Name',
//               EditNameFormPage(),
//               screenWidth,
//             ),
//             buildUserInfoDisplay(
//               user.phone,
//               'Phone',
//               EditPhoneFormPage(),
//               screenWidth,
//             ),
//             buildUserInfoDisplay(
//               user.email,
//               'Email',
//               EditEmailFormPage(),
//               screenWidth,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: buildAbout(user, screenWidth),
//             ),
//             Center(
//               child: userProvider.isLoggedIn
//                   ? 
//                   CustomElevatedButton(
//                     text: 'Logout',
//                     onPressed: () {
//                       userProvider.logout();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Logged out successfully!'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                     },
//                   )
//                   : ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, AppRoutes.login);
//                       },
//                       child: Text('Login'),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildUserInfoDisplay(
//     String getValue,
//     String title,
//     Widget editPage,
//     double screenWidth,
//   ) {
//     final isSmallScreen = screenWidth < 600;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 1),
//           Container(
//             width: isSmallScreen ? double.infinity : 500,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       navigateSecondPage(editPage);
//                     },
//                     child: Text(
//                       getValue,
//                       style: TextStyle(fontSize: 16, height: 1.4),
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   Icons.keyboard_arrow_right,
//                   color: Colors.grey,
//                   size: 40.0,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildAbout(User user, double screenWidth) {
//     final isSmallScreen = screenWidth < 600;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Tell Us About Yourself',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 1),
//           Container(
//             width: isSmallScreen ? double.infinity : 500,
//             height: 200,
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey,
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       navigateSecondPage(EditDescriptionFormPage());
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(
//                           user.aboutMeDescription,
//                           style: TextStyle(
//                             fontSize: 16,
//                             height: 1.4,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   Icons.keyboard_arrow_right,
//                   color: Colors.grey,
//                   size: 40.0,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   FutureOr onGoBack(dynamic value) {
//     setState(() {});
//   }

//   void navigateSecondPage(Widget editForm) {
//     Route route = MaterialPageRoute(builder: (context) => editForm);
//     Navigator.push(context, route).then(onGoBack);
//   }
// }
