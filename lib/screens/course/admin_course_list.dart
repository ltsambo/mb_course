import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/screens/course/course_create.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/course_porvider.dart';
import '../../widgets/course_card.dart';

class AdminCourseListScreen extends StatefulWidget {
  const AdminCourseListScreen({super.key});

  @override
  State<AdminCourseListScreen> createState() => _AdminCourseListScreenState();
}

class _AdminCourseListScreenState extends State<AdminCourseListScreen> {
    
  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final courses = courseProvider.courses;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     // Back button action
        //   },
        // ),
        title: DefaultTextWg(text: "Course List", fontSize: 24, fontColor: whiteColor,),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, color: whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCourseScreen(),
                ),
              );
            },
          ),
        ],
        centerTitle: false,
      ),
      backgroundColor: whiteColor,
      body: courses.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {              
              return AdminCourseCard(course: courses[index]);
            },
          ),
      );          
  }
}
