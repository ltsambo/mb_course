import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/course.dart';
import '../screens/course/course_detail_screen.dart';

class CourseCarousel extends StatelessWidget {
  final List<Course> courses;

  CourseCarousel({required this.courses});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: courses.map((course) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // Navigate to course details on carousel item click
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(course: course),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(course.coverImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      course.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
