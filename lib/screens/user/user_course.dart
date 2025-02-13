import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/order_provider.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../widgets/course_card.dart';
import '../auth/login_screen.dart';

class UserCourseListScreen extends StatefulWidget {
  const UserCourseListScreen({super.key});

  @override
  State<UserCourseListScreen> createState() => _UserCourseListScreenState();
}

class _UserCourseListScreenState extends State<UserCourseListScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch enrolled courses from UserProvider after the widget tree is built
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchEnrolledCourses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: DefaultTextWg(text: "My Courses", fontSize: 24, fontColor: whiteColor),
        centerTitle: false,
      ),
      body: userProvider.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : userProvider.isAuthenticated && orderProvider.enrolledCourses.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: ListView.builder(
                    itemCount: orderProvider.enrolledCourses.length,
                    itemBuilder: (context, index) {
                      final course = orderProvider.enrolledCourses[index];
                      return CourseCard(course: course);
                    },
                  ),
                )
              : _buildEmptyState(userProvider),
    );
  }

  // Build Empty State UI when no courses are found
  Widget _buildEmptyState(UserProvider userProvider) {
    return Column(
      children: [
        Spacer(),
        Icon(Icons.list_alt_outlined, size: 60, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          userProvider.isAuthenticated
              ? "No enrolled courses found."
              : "Log in to see your courses",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!userProvider.isAuthenticated)
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserLoginScreen()),
                  );
                },
                child: Text('Sign in / Register'),
              )
            else
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: Text('Find Courses'),
              ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}
