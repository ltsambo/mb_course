import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/providers/user_provider.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/course_porvider.dart';
import '../../widgets/course_card.dart';
import '../auth/login_screen.dart';


class UserCourseListScreen extends StatelessWidget {
  const UserCourseListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Back button action
        //   },
        // ),
        title: DefaultTextWg(text: "My Courses", fontSize:  24, fontColor: whiteColor,),        
        centerTitle: false,
      ),
      body: userProvider.isAuthenticated ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: 
          Expanded(          
          child: ListView.builder(
            itemCount: courseProvider.courses.length,
            itemBuilder: (context, index) {
              final course = courseProvider.courses[index];
              return CourseCard(course: course,);
            },
          ),
        )
      ): Column(
          children: [
            Spacer(),  // Pushes the empty cart section to center vertically
            Icon(Icons.list_alt_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            // Text(
            //   'Your course list are empty',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 5),
            Text(
              'Log in to see your courses',
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
                      MaterialPageRoute(
                        builder: (context) => UserLoginScreen(),
                      ),
                    );
                  },
                  child: Text('Sign in / Register'),
                  ) 
                else
                  OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                  child: Text('Continue Shopping'),
                ),                 
                             
              ],
            ),
            Spacer(),  // Pushes the recommendation section to the bottom
          ],
        ),
    );
  }
}
