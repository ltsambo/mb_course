import 'package:flutter/material.dart';
import 'package:mb_course/widgets/lesson_card.dart';
import '../models/course.dart';
import '../widgets/video_player_widget.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Video Section
            VideoPlayerWidget(url: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_20mb.mp4'),

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
                    course.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Created by: ${course.createdBy}'),
                  SizedBox(height: 8),
                  Text('Last updated on: ${course.lastUpdated}'),
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