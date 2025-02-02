import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';

class CourseProvider with ChangeNotifier {
  final List<Course> _courses = [
    Course(
      id: '1',
      title: 'Flutter Development',
      coverImage: 'assets/flutter_course.png',
      duration: '20 hours',
      description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
      createdBy: 'Alex',
      lastUpdated: '12 Jan 2025',
      isOnSale: true,
      price: 2500,
      salePrice: 2300,
      demoVideo: '',
      lessons: [
        Lesson(id: '1', title: 'Introduction', isDemo: true),
        Lesson(id: '2', title: 'State Management', isDemo: false),
        Lesson(id: '3', title: 'Provider Basics', isDemo: false),
      ],
    ),
    Course(
      id: '2',
      title: 'Django Backend',
      coverImage: 'assets/django_course.png',
      duration: '15 hours',
      description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
      createdBy: 'Alex',
      lastUpdated: '12 Jan 2025',
      isOnSale: true,
      price: 2500,
      salePrice: 2300,
      demoVideo: '',
      lessons: [
        Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
        Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
        Lesson(id: '3', title: 'REST APIs', isDemo: false),        
      ],
    ),
    Course(
      id: '3',
      title: 'AWS Beginner',
      coverImage: 'assets/aws_course.jpeg',
      duration: '13 hours',
      description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
      createdBy: 'Alex',
      lastUpdated: '12 Jan 2025',
      isOnSale: false,
      price: 2500,
      salePrice: 2300,
      demoVideo: '',
      lessons: [
        Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
        Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
        Lesson(id: '3', title: 'REST APIs', isDemo: false),
        Lesson(id: '4', title: 'IAM', isDemo: false),
        Lesson(id: '5', title: 'Elastic BeanStalk', isDemo: false),
        Lesson(id: '6', title: 'ROUTE 53', isDemo: false),
      ],
    ),
    Course(
      id: '4',
      title: 'DotNET API',
      coverImage: 'assets/dotnet_course.jpeg',
      duration: '30 hours',
      description: 'Lorem ipsum dolor sit amet . The graphic and typographic operators know this well, in reality all the professions dealing with the universe of communication have a stable relationship with these words, but what is it? Lorem ipsum is a dummy text without any sense. It is a sequence of Latin words that, as they are positioned, do not form sentences with a complete sense, but give life to a test text useful to fill spaces that will subsequently be occupied from ad hoc texts composed by communication professionals.',
      createdBy: 'Morgan',
      lastUpdated: '20 Jan 2025',
      isOnSale: false,
      price: 2500,
      salePrice: 2300,
      demoVideo: '',
      lessons: [
        Lesson(id: '1', title: 'Setup and Installation', isDemo: true),
        Lesson(id: '2', title: 'Models and Migrations', isDemo: false),
        Lesson(id: '3', title: 'REST APIs', isDemo: false),
        Lesson(id: '4', title: 'API Backend', isDemo: false),
        Lesson(id: '5', title: 'API Introduction', isDemo: false),
        Lesson(id: '6', title: 'Beginner APP', isDemo: false),
      ],
    ),
  ];

  List<Course> get courses => _courses;

  Course findProdById(String productId) {
    return _courses.firstWhere((element) => element.id == productId);
  }

}
