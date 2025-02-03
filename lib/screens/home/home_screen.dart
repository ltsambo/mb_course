import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/screens/auth/login_screen.dart';
import 'package:mb_course/widgets/course_card.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';
import '../../widgets/course_carousel.dart';
import '../../providers/course_porvider.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = Provider.of<CourseProvider>(context).courses;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userProvider.isAuthenticated ? 
              DefaultTextWg(text: 'Welcome Back', fontSize: 16, fontWeight: FontWeight.bold, fontColor: Colors.white,) :
              DefaultTextWg(text: 'Course List', fontSize: 24, fontWeight: FontWeight.bold, fontColor: whiteColor,),
            if(userProvider.isAuthenticated)
              DefaultTextWg(text: userProvider.isAuthenticated ? userProvider.currentUser!.username : '', fontSize: 15, fontColor: blackColor,)                                                       
          ],
        ), 
        
        actions: [
          if (userProvider.isAuthenticated)          
            GestureDetector(
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(),
                ),);               
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: whiteColor,                  
                  backgroundImage: AssetImage(
                    userProvider.currentUser!.image, // Replace with user image source
                  ),
                ),
              ),
            )
          else
            IconButton(
              color: whiteColor,
            icon: Icon(Icons.login),
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
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Courses refreshed!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: Column(
            children: [
              // Carousel Section
              SizedBox(
                height: 24,
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
        ),
        floatingActionButton: userProvider.isAuthenticated
        ? null
        : FloatingActionButton(
            onPressed: () {                
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserLoginScreen(),
                ),
              );
              // Navigator.pushNamed(context, logInScreenRoute);
            },
            backgroundColor: const Color.fromARGB(255, 54, 109, 72),
            child: Icon(Icons.login_rounded, color: Colors.white,),
          ),
    );
  }
}
