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
    case managementScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ManagementItemsScreen(),
      );
    case listUserScreenRoute:
      return MaterialPageRoute(
        builder: (context) => UserListScreen(),
      );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => HomeScreen(),
      );
  }
}
