import 'package:flutter/material.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'route_constants.dart';
import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );    
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => UserLoginScreen(),
      );
    // case courseDetailScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => CourseDetailScreen(course: course,),
    //   );
    case settingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      );
    // case managementScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ManagementItemsScreen(),
    //   );
    case userListScreenRoute:
      return MaterialPageRoute(
        builder: (context) => UserListScreen(),
      );
    // case userProfileScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => () // UserProfileScreen(), // Replace with your Page Settings screen    
    // );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => HomeScreen(),
      );
  }
}
