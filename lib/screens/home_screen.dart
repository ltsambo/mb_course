import 'package:flutter/material.dart';
import 'package:mb_course/widgets/course_card.dart';
import 'package:provider/provider.dart';
import '../config/app_routes.dart';
import '../widgets/course_carousel.dart';
import '../providers/course_porvider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = Provider.of<CourseProvider>(context).courses;

    return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userProvider.isLoggedIn ? 'Welcome Back' : 'Course List'),
              if (userProvider.isLoggedIn)
                Text(
                  userProvider.username ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  
                ),
            ],
          ),
          actions: [
            if (userProvider.isLoggedIn)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/user_avatar.png'), // Replace with user image source
                ),
              )
            else
              IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshed the courses!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Column(
              children: [
                // Carousel Section
                SizedBox(
                  height: 16,
                ),
                CourseCarousel(courses: courses),
                SizedBox(
                  height: 20,
                ),
                // Course List
                Expanded(
                  child: ListView.builder(
                    itemCount: courseProvider.courses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.courses[index];
                      return CourseCard(course: course,);
                    },
                  ),
                )
              ],
            )
          )
        );
  }
}
