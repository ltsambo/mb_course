import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/business.dart';
import 'package:mb_course/providers/order_provider.dart';
import 'package:mb_course/screens/auth/change_password.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/screens/business/contact_us.dart';
import 'package:mb_course/screens/business/update_contact.dart';
import 'package:mb_course/screens/carousel/carousel_screen.dart';
import 'package:mb_course/screens/course/admin_course_list.dart';
import 'package:mb_course/screens/order/accept_payment.dart';
import 'package:mb_course/screens/order/order_screen.dart';
import 'package:mb_course/screens/user/user_profile.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../providers/user_provider.dart';
import '../../utlis/auth_utlis.dart';
import '../../widgets/section_widgets.dart';
import '../business/list_payment_bank_info.dart';
import '../user/user_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {  
  bool showDropdown = false; // Track dropdown visibility
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchUserOrders(context);
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);   
    final orderProvider = Provider.of<OrderProvider>(context);    

    final toPayCount = orderProvider.statusCounts['pending_upload'] ?? 0;
    final pendingAcceptanceCount = orderProvider.statusCounts['pending_acceptance'] ?? 0;
    final acceptedCount = orderProvider.statusCounts['accepted'] ?? 0;
    
    // print('status count ${orderProvider['status_count']}');
    return Scaffold(
      backgroundColor: backgroundColor, // Light beige background
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const DefaultTextWg(text: 'Settings', fontSize: 24, fontColor: whiteColor,),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, size: 24, color: whiteColor,),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ), 
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            // Management Section
            if (userProvider.currentUser != null) ...[
              if (userProvider.currentUser != null && userProvider.currentUser!.role == "admin")
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
                            builder: (context) => AdminCourseListScreen(), 
                          ),
                        );
                      },
                    ),
                    // BuildSubMenuItemWg(
                    //   text: "Course Details",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => UserListScreen(), 
                    //       ),
                    //     );
                    //   },
                    // ),
                    BuildSubMenuItemWg(
                      text: "Accept Payments",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AceeptOrderListScreen(), 
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
                            builder: (context) => CarouselScreen(), 
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
                            builder: (context) => UpdateBusinessScreen(), 
                          ),
                        );
                      },
                    ),
                    BuildSubMenuItemWg(
                      text: "Payment Info",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListPaymentBankInfoScreen(), 
                          ),
                        );
                      },
                    ),
                    // BuildSubMenuItemWg(
                    //   text: "Privacy Policy",
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => UserListScreen(), 
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // My Purchases Text
                        Text(
                          'My Purchases',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        // View Purchase History with Arrow
                        InkWell(
                          onTap: () {
                            // Navigate to purchase history screen
                          },
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderListScreen(),
                                    ),
                                  )
                                },
                                child: DefaultTextWg(text: 'View Purchase History', fontWeight: FontWeight.normal,)                                
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),                                       
                    const SizedBox(height: 8),
                    Divider(height: 1),
                    Container(                        
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // To Pay
                            _buildPurchaseOption(
                              icon: Icons.account_balance_wallet_outlined,
                              label: 'To Pay',
                              badgeCount: toPayCount,
                            ),

                            // To Ship
                            _buildPurchaseOption(
                              icon: Icons.assignment_turned_in_sharp,
                              label: 'To Accept',
                              badgeCount: pendingAcceptanceCount
                            ),

                            // To Receive
                            _buildPurchaseOption(
                              icon: Icons.local_mall_outlined,
                              label: 'Enrolled',
                              badgeCount: acceptedCount
                            ),

                            // // To Rate
                            // _buildPurchaseOption(
                            //   icon: Icons.star_border,
                            //   label: 'To Rate',
                            //   badgeCount: 14,
                            // ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
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
            ],
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
                
                // BuildListItemWg(
                //   icon: Icons.logout,
                //   text: "Logout",
                //   onTap: () {
                //     handleLogout(context);
                //   },
                //   showDropdown: false,
                //   isDropdownMenu: false,
                // ),
              ],
            ),
            SizedBox(height: 16,),
            Card(
              child: Container(
                width: double.infinity,  // Make the button stretch horizontally
                margin: EdgeInsets.symmetric(horizontal: 16.0),  // Add margin on sides
                // decoration: BoxDecoration(                  
                //   border: Border.all(color: Colors.grey[300]!),
                // ),
                child: userProvider.currentUser != null 
                ? TextButton(
                  onPressed: () {
                    handleLogout(context);
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserLoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign in / Register',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),            
          ],
        )
        // : EmptyScreen(
        //   imagePath: 'assets/login_lock.jpg', title: 'Authentication required!', subtitle: 'Please login to access this page', buttonText: 'Login', 
        //   onPressed: () {                
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => UserLoginScreen(),
        //         ),
        //       );
        //       // Navigator.pushNamed(context, logInScreenRoute);
        //     },
        // ),
      ),
    );
  }      
  Widget _buildPurchaseOption({required IconData icon, required String label, int? badgeCount}) {
    return Column(
      children: [
        badges.Badge(
          showBadge: badgeCount != null && badgeCount > 0,
          badgeContent: Text(
            '$badgeCount',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.red,
            padding: EdgeInsets.all(5),
          ),
          position: badges.BadgePosition.topEnd(top: -8, end: -8),
          child: Icon(icon, size: 32),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );    
  }
}
