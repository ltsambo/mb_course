import 'package:flutter/material.dart';
import 'package:mb_course/consts/consts.dart';
import 'package:mb_course/widgets/custom_button.dart';
import 'package:mb_course/widgets/default_text.dart';
import 'package:mb_course/widgets/lesson_card.dart';
import '../../models/course.dart';
import '../../widgets/video_player_widget.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: DefaultTextWg(text: course.title, fontColor: whiteColor, fontSize: 20,),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: whiteColor,)),
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
                  if (!(course.isPurchased ?? false)) 
                  CustomElevatedButton(
                    text: 'Add to cart', 
                    onPressed: () => {}),
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