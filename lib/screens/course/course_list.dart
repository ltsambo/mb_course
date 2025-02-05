import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/route/screen_export.dart';
import 'package:mb_course/screens/course/course_create.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:provider/provider.dart';

import '../../providers/course_porvider.dart';
import '../../widgets/course_card.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
    
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
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: courses.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: courses[index]);
            },
          ),
      );          
  }
}
