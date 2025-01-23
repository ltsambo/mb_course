import 'package:flutter/material.dart';
import 'package:mb_course/widgets/default_text.dart';

import '../models/course.dart';
import '../screens/course/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(course.coverImage, width: 50, height: 50),
        title: DefaultTextWg(text: course.title),
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
