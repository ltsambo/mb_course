import 'package:flutter/material.dart';
import 'package:mb_course/providers/business.dart';
import 'package:mb_course/providers/cart_provider.dart';
import 'package:mb_course/providers/order_provider.dart';
import 'package:mb_course/screens/cart/cart_screen.dart';
import 'package:mb_course/screens/user/user_course.dart';
import 'package:mb_course/widgets/custom_bottom_nav_bar.dart';
// import 'package:mb_course/screens/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'providers/carousel.dart';
import 'route/screen_export.dart';
import 'providers/course_porvider.dart';
import 'providers/user_provider.dart';
import 'screens/auth/login_screen.dart';
import 'services/navigation_service.dart';
// import 'package:motion_tab_bar_v2/motion-tab-bar.dart'; // Import the MotionTabBar package

Future<void> initializeAuth() async {
  await AuthHelper.clearToken(); // Ensure old tokens are cleared if user is logged out
  String? token = await AuthHelper.getToken();
  if (token == null || token.isEmpty) {
    print("No valid token found at startup.");
  } else {
    print("Valid token found: $token");
  }
}

Future<void> initializeCarousel() async {
  await CarouselProvider().fetchCarousels();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async functions run before UI starts
  await initializeAuth(); // Initialize the UserProvider
  initializeCarousel(); // Initialize the CarouselProvider
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
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CarouselProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => BankInfoProvider()),
        ChangeNotifierProvider(create: (_) => PaymentBankInfoProvider()),
      ],
      child: 
      MaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Testing App',
        initialRoute: AppRoutes.home,
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
