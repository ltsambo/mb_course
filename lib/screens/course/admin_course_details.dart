import 'package:flutter/material.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/lesson_card.dart';
import '../../models/course.dart';
import '../../widgets/video_player_widget.dart';

class AdminCourseDetailScreen extends StatelessWidget {
  final Course course;
  
  const AdminCourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    print('demo video ${course.demoVideo}');
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Video Section
            course.demoVideo == null ? Image.asset('assets/not-available.jpeg'):
            VideoPlayerWidget(url: course.demoVideo!),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    course.description.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Created by: ${course.instructorUsername}'),
                  SizedBox(height: 8),
                  Text('Last updated on: ${course.modifiedOn}'),
                  SizedBox(height: 8),
                  Text('Price: ${course.price}'),
                  SizedBox(height: 16),                  
                  Text(
                    'What youll learn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // ...course.learningPoints.map((point) => Text('• $point')).toList(),
                ],
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Lessons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            LessonCard(course: course)
          ],
        ),
      ),
    );
  }
}