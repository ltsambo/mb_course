import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ✅ Redirect to login and clear navigation stack
  static void navigateToLogin() {
    print('navigate to login ${navigatorKey.currentState}');

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    print('navigate to login ned');
  }

  // ✅ Navigate to any screen
  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }
}