import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/auth/change_password.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/screens/business/contact_us.dart';
import 'package:mb_course/screens/core/empty_screen.dart';
import 'package:mb_course/screens/course/course_list.dart';
import 'package:mb_course/screens/user/user_profile.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../utlis/auth_utlis.dart';
import '../../widgets/section_widgets.dart';
import '../user/user_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {  
  bool showDropdown = false; // Track dropdown visibility

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const DefaultTextWg(text: 'Settings', fontSize: 24, fontColor: whiteColor,),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: userProvider.isAuthenticated ? ListView(
          children: [
            // Management Section
            BuildSectionCardWg(
              title: "Management",
              children: [
                BuildListItemWg(
                  icon: Icons.account_circle_outlined,
                  text: "Management Panel",
                  onTap: () {
                    setState(() {
                      showDropdown = !showDropdown; // Toggle dropdown
                    });
                  },
                  showDropdown: showDropdown,
                  isDropdownMenu: true,
                ),
                if (showDropdown) ...[
                  BuildSubMenuItemWg(
                    text: "User",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(), 
                        ),
                      );
                    },
                  ),
                  // BuildSubMenuItemWg(
                  //   text: "User Role",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => UserListScreen(), 
                  //       ),
                  //     );
                  //   },
                  // ),
                  Divider(indent: 35, endIndent: 25,),
                  BuildSubMenuItemWg(
                    text: "Course",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseListScreen(), 
                        ),
                      );
                    },
                  ),
                  BuildSubMenuItemWg(
                    text: "Course Details",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(), 
                        ),
                      );
                    },
                  ),
                  Divider(indent: 35, endIndent: 25,),
                  BuildSubMenuItemWg(
                    text: "Carousel",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(), 
                        ),
                      );
                    },
                  ),
                  BuildSubMenuItemWg(
                    text: "Contact Us",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(), 
                        ),
                      );
                    },
                  ),
                  BuildSubMenuItemWg(
                    text: "Privacy Policy",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(), 
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            // My Information Section
            BuildSectionCardWg(
              title: "My Information",
              children: [
                BuildListItemWg(
                  icon: Icons.person_outline,
                  text: "Profile",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(userId: userProvider.currentUser!.id,), 
                        ),
                    );
                  },
                  showDropdown: false,
                  isDropdownMenu: false,
                ),
                BuildListItemWg(
                  icon: Icons.lock_outline,
                  text: "Change Password",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(), 
                        ),
                    );
                  },
                  showDropdown: false,
                  isDropdownMenu: false,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Security Section
            BuildSectionCardWg(
              title: "Security",
              children: [
                BuildToogleItemWg(
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
            BuildSectionCardWg(
              title: "Other",
              children: [
                BuildListItemWg(
                  icon: Icons.mail_outline,
                  text: "Contact Us",
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ContactUsScreen())
                    );
                  },
                  showDropdown: false,
                  isDropdownMenu: false,
                ),
                BuildListItemWg(
                  icon: Icons.privacy_tip_outlined,
                  text: "Privacy Policy",
                  onTap: () {
                    // Privacy policy navigation
                  },
                  showDropdown: false,
                  isDropdownMenu: false,
                ),
                
                BuildListItemWg(
                  icon: Icons.logout,
                  text: "Logout",
                  onTap: () {
                    handleLogout(context);
                  },
                  showDropdown: false,
                  isDropdownMenu: false,
                ),
              ],
            ),
          ],
        ): EmptyScreen(
          imagePath: 'assets/login_lock.jpg', title: 'Authentication required!', subtitle: 'Please login to access this page', buttonText: 'Login', 
          onPressed: () {                
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginScreen(),
                ),
              );
              // Navigator.pushNamed(context, logInScreenRoute);
            },
        ),
      ),
    );
  }    
}
