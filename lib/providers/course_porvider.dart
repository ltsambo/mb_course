import 'dart:io';

import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/course.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'user_provider.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  int _totalCourses = 0;

  List<Course> get courses => _courses;
  int get totalCourses => _totalCourses;

  Future<void> fetchCourses() async {
    final url = Uri.parse(coursesUrl); // Replace with actual API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('response data $responseData');
        // _totalCourses = int.tryParse(responseData['data']['total_courses'].toString()) ?? 0; // Extract total course count
        // print('total courses $totalCourses');
        _courses = List<Course>.from(
          (responseData['data']['courses'] as List).map((course) => Course.fromJson(course))
        );
        // (responseData['data']['courses'] as List)
        //     .map((course) => Course.fromJson(course))
        //     .toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (error) {
      print('error $error');
      throw error;
    }
  }

  // ✅ Function to create a new course with file upload
  Future<bool> createCourse({
    required String title,
    required int totalDuration,
    required String? recommendation,
    required String? description,
    required String instructorUsername,
    required bool isOnSale,
    required double price,
    required double salePrice,
    File? coverImage,   // Add cover image
    File? demoVideo,    // Add demo video
  }) async {
    final url = Uri.parse(courseCreateUrl);
    final token = await AuthHelper.getToken();
    print('toke $token');

    try {
      var request = http.MultipartRequest("POST", url);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token'; 
      }

      request.fields['title'] = title;
      request.fields['total_duration'] = totalDuration.toString();
      request.fields['recommendation'] = recommendation ?? "";
      request.fields['description'] = description ?? "";
      request.fields['instructor'] = "1";
      request.fields['is_on_sale'] = isOnSale.toString();
      request.fields['price'] = price.toString();
      request.fields['sale_price'] = salePrice.toString();

      // ✅ Attach cover image if provided
      if (coverImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('cover_image', coverImage.path),
        );
      }

      // ✅ Attach demo video if provided
      if (demoVideo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('demo_video', demoVideo.path),
        );
      }

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        fetchCourses();
        return true;
      } else {
        print("Course creation failed: $responseData");
        return false;
      }
    } catch (error) {
      print("Error creating course: $error");
      return false;
    }
  }

  Course findProdById(String productId) {
    return _courses.firstWhere((element) => element.id == productId);
  }
}

// class CourseProvider with ChangeNotifier {
//   final List<Course> _courses = [
    // Course(
    //   id: '1',
    //   title: 'Flutter Development',
    //   coverImage: 'assets/flutter_course.png',
    //   duration: '20 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Alex',
    //   lastUpdated: '12 Jan 2025',
    //   isOnSale: true,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Introduction', isDemo: true),
    //     Lesson(id: '2', title: 'State Management', isDemo: false),
    //     Lesson(id: '3', title: 'Provider Basics', isDemo: false),
    //   ],
    // ),
    // Course(
    //   id: '2',
    //   title: 'Django Backend',
    //   coverImage: 'assets/django_course.png',
    //   duration: '15 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Alex',
    //   lastUpdated: '12 Jan 2025',
    //   isOnSale: true,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),        
    //   ],
    // ),
    // Course(
    //   id: '3',
    //   title: 'AWS Beginner',
    //   coverImage: 'assets/aws_course.jpeg',
    //   duration: '13 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Alex',
    //   lastUpdated: '12 Jan 2025',
    //   isOnSale: false,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),
    //     Lesson(id: '4', title: 'IAM', isDemo: false),
    //     Lesson(id: '5', title: 'Elastic BeanStalk', isDemo: false),
    //     Lesson(id: '6', title: 'ROUTE 53', isDemo: false),
    //   ],
    // ),
    // Course(
    //   id: '4',
    //   title: 'DotNET API',
    //   coverImage: 'assets/dotnet_course.jpeg',
    //   duration: '30 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Morgan',
    //   lastUpdated: '20 Jan 2025',
    //   isOnSale: false,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),
    //     Lesson(id: '4', title: 'API Backend', isDemo: false),
    //     Lesson(id: '5', title: 'API Introduction', isDemo: false),
    //     Lesson(id: '6', title: 'Beginner APP', isDemo: false),
    //   ],
    // ),
    // Course(
    //   id: '5',
    //   title: 'DotNET API 2',
    //   coverImage: 'assets/dotnet_course.jpeg',
    //   duration: '30 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Morgan',
    //   lastUpdated: '20 Jan 2025',
    //   isOnSale: false,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),
    //     Lesson(id: '4', title: 'API Backend', isDemo: false),
    //     Lesson(id: '5', title: 'API Introduction', isDemo: false),
    //     Lesson(id: '6', title: 'Beginner APP', isDemo: false),
    //   ],
    // ),
    // Course(
    //   id: '6',
    //   title: 'DotNET API 6',
    //   coverImage: 'assets/dotnet_course.jpeg',
    //   duration: '30 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Morgan',
    //   lastUpdated: '20 Jan 2025',
    //   isOnSale: false,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),
    //     Lesson(id: '4', title: 'API Backend', isDemo: false),
    //     Lesson(id: '5', title: 'API Introduction', isDemo: false),
    //     Lesson(id: '6', title: 'Beginner APP', isDemo: false),
    //   ],
    // ),
    // Course(
    //   id: '7',
    //   title: 'DotNET API 7',
    //   coverImage: 'assets/dotnet_course.jpeg',
    //   duration: '30 hours',
    //   description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
    //   createdBy: 'Morgan',
    //   lastUpdated: '20 Jan 2025',
    //   isOnSale: false,
    //   price: 2500,
    //   salePrice: 2300,
    //   demoVideo: '',
    //   lessons: [
    //     Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
    //     Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
    //     Lesson(id: '3', title: 'REST APIs', isDemo: false),
    //     Lesson(id: '4', title: 'API Backend', isDemo: false),
    //     Lesson(id: '5', title: 'API Introduction', isDemo: false),
    //     Lesson(id: '6', title: 'Beginner APP', isDemo: false),
    //   ],
    // ),
//   ];

//   List<Course> get courses => _courses;

//   Course findProdById(String productId) {
//     return _courses.firstWhere((element) => element.id == productId);
//   }

// }
