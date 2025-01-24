import 'package:flutter/material.dart';
import 'package:mb_course/route/route_constants.dart';
import 'package:mb_course/screens/cart/cart_screen.dart';
import 'package:mb_course/screens/user/user_course.dart';
import 'package:mb_course/widgets/custom_bottom_nav_bar.dart';
// import 'package:mb_course/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'route/screen_export.dart';
import 'providers/course_porvider.dart';
import 'providers/user_provider.dart';
import 'screens/auth/login_screen.dart';
// import 'package:motion_tab_bar_v2/motion-tab-bar.dart'; // Import the MotionTabBar package

void main() {
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: 
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Testing App',
        initialRoute: homeScreenRoute,
        routes: {
          AppRoutes.home: (context) => MainScreen(),
          AppRoutes.login: (context) => UserLoginScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    UserCourseListScreen(),
    CartScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BtmMotionNavbar(onItemTapped: _onItemTapped,)
      
    );
  }
}
