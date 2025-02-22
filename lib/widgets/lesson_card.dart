import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../models/course.dart';
// import '../providers/user_provider.dart';

class LessonCard extends StatelessWidget {  
  final Course course;
  const LessonCard({required this.course});

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: course.lessons!.length,
      itemBuilder: (context, index) {
        final lesson = course.lessons![index];
        return ListTile(
          leading: Text((index + 1).toString()),
          title: Text(lesson.title),
          trailing: lesson.isDemo || (course.isPurchased ?? true)
              ? Icon(Icons.play_circle_fill)
              : Icon(Icons.lock),
          onTap: lesson.isDemo || (course.isPurchased ?? true)
              ? () {
                  // Play video
                }
              : null,
        );                        
      },
    );
  }
}
