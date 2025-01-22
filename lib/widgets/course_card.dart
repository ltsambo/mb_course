import 'package:flutter/material.dart';

import '../models/course.dart';
import '../screens/course/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(course.coverImage, width: 50, height: 50),
        title: Text(course.title),
        subtitle: Text('${course.duration} | ${course.lessons.length} lessons'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(course: course),
          ),
        )
      ),
    );    
  }
}
