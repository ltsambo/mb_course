
import 'package:mb_course/models/lesson.dart';

class Course {
  final int id;
  final String title, instructorUsername;
  final String? recommendation;
  final int totalDuration;
  final String? description;
  final String coverImage;
  final bool isOnSale;
  final double price;
  final double salePrice;
  // final int lessonCount; // Added to track lesson count
  final List<Lesson>? lessons;
  final String modifiedOn;

  Course({
    required this.id,
    required this.title,
    required this.instructorUsername,
    this.recommendation,
    required this.totalDuration,
    this.description,
    required this.coverImage,
    required this.isOnSale,
    required this.price,
    required this.salePrice,
    // required this.lessonCount,
    this.lessons,
    required this.modifiedOn,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      title: json['title'],
      instructorUsername: json['instructor_username'],
      recommendation: json['recommendation'],
      totalDuration: json['total_duration'],
      description: json['description'] ?? "No description available",
      coverImage: json['cover_image'] ?? "http://10.10.11.11:8000/media/course/Queries%20for%20design%20issues/no-image-available.jpeg",
      isOnSale: json['is_on_sale'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      salePrice: double.tryParse(json['sale_price'].toString()) ?? 0.0,
      // lessonCount: (json['lessons'] as List).map((lesson) => Lesson.fromJson(lesson)).toList(), // Count lessons from API
      lessons: (json['lessons'] as List).map((lesson) => Lesson.fromJson(lesson)).toList(),
      modifiedOn: json['modified_on'],
    );
  }
}

// class Course {
//   final int id;
//   final String title, coverImage, duration, description, instructorName, modifiedOn;
//   final bool isOnSale;
//   final double price, salePrice;
//   final String demoVideo;
//   final List<Lesson> lessons;

//   Course({
//     required this.id,
//     required this.title,
//     required this.coverImage,
//     required this.duration,
//     required this.description,
//     required this.instructorName,
//     required this.modifiedOn,
//     required this.isOnSale,
//     required this.price,
//     required this.salePrice,
//     required this.demoVideo,
//     required this.lessons,    
//   });
// }

// import 'dart:convert';

// class Course {
//   final int id;
//   final String title;
//   final String? recommendation;
//   final int totalDuration;
//   final String? description;
//   final String createdOn;
//   final String modifiedOn;
//   final int instructorId;
//   final String? instructorUsername;
//   final String coverImage;
//   final String? demoVideo;
//   final bool isPublished;
//   final bool isOnSale;
//   final double price;
//   final double salePrice;

//   Course({
//     required this.id,
//     required this.title,
//     this.recommendation,
//     required this.totalDuration,
//     this.description,
//     required this.createdOn,
//     required this.modifiedOn,
//     required this.instructorId,
//     this.instructorUsername,
//     required this.coverImage,
//     this.demoVideo,
//     required this.isPublished,
//     required this.isOnSale,
//     required this.price,
//     required this.salePrice,
//   });

//   // Factory method to create a Course object from JSON
//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['id'],
//       title: json['title'],
//       recommendation: json['recommendation'],
//       totalDuration: json['total_duration'],
//       description: json['description'] ?? "No description available",
//       createdOn: json['created_on'],
//       modifiedOn: json['modified_on'],
//       instructorId: json['instructor'],
//       instructorUsername: json['instructor_username'],
//       coverImage: json['cover_image'] ?? "https://via.placeholder.com/150",
//       demoVideo: json['demo_video'],
//       isPublished: json['is_published'],
//       isOnSale: json['is_on_sale'],
//       price: (json['price'] as num).toDouble(),
//       salePrice: (json['sale_price'] as num).toDouble(),
//     );
//   }

  // Convert Course object to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     "id": id,
  //     "title": title,
  //     "recommendation": recommendation,
  //     "total_duration": totalDuration,
  //     "description": description,
  //     "created_on": createdOn,
  //     "modified_on": modifiedOn,
  //     "instructor": instructorId,
  //     "instructor_username": instructorUsername,
  //     "cover_image": coverImage,
  //     "demo_video": demoVideo,
  //     "is_published": isPublished,
  //     "is_on_sale": isOnSale,
  //     "price": price,
  //     "sale_price": salePrice,
  //   };
  // }
//   Map<String, dynamic> parseCourses(String responseBody) {
//     final parsed = json.decode(responseBody);
//     return {
//       "total_courses": parsed['data']['total_courses'], // Extract total count
//       "courses": List<Course>.from(parsed['data']['courses'].map((course) => Course.fromJson(course))),
//     };
//   }
// }

// // Helper function to parse a list of courses from JSON
// List<Course> parseCourses(String responseBody) {
//   final parsed = json.decode(responseBody);
//   return List<Course>.from(parsed['data'].map((course) => Course.fromJson(course)));
// }
