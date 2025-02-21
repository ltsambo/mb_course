import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../providers/carousel.dart';

class CourseCarousel extends StatelessWidget {
  
  CourseCarousel({Key? key});

  @override
  Widget build(BuildContext context) {
    final carousels = Provider.of<CarouselProvider>(context).carousels;
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: carousels.map((carousel) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // Navigate to course details on carousel item click
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => CourseDetailScreen(course: course),
                //   ),
                // );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: carousel.image == null ? AssetImage('assets/not-available.jpeg') : NetworkImage(carousel.image!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      carousel.title,
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
