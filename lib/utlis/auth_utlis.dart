// utils/auth_utils.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

/// Common function to handle logout
void handleLogout(BuildContext context) {
  // Clear user session using UserProvider
  Provider.of<UserProvider>(context, listen: false).logout(context);

  // Navigate to the login screen
  Navigator.pushReplacementNamed(context, '/');

  // Show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Logged out successfully')),
  );
}
