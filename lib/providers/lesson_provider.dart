import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mb_course/config/api_config.dart';
import 'package:mb_course/models/lesson.dart';
import 'package:mb_course/providers/course_porvider.dart';
import 'package:path/path.dart';

import 'user_provider.dart';


class LessonProvider with ChangeNotifier {
  List<Lesson> _lessons = [];
  List<CourseDropDown> _courses = [];
  bool _isLoading = false;

  List<Lesson> get lessons => _lessons;
  List<CourseDropDown> get courses => _courses;
  bool get isLoading => _isLoading;

  Future<void> fetchDropDownCourses() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(coursesUrl));

      if (response.statusCode == 200) {
        final courseData = json.decode(response.body);
        _courses = List<CourseDropDown>.from(
          (courseData['data']['courses'] as List).map((course) => CourseDropDown.fromJson(course))
        );        
      } else {
        throw Exception("Failed to load courses");
      }
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLesson(Lesson lesson, File? videoFile) async {
    try {
      final token = await AuthHelper.getToken();
      var request = http.MultipartRequest('POST', Uri.parse(lessonsUrl))
      ..headers['Authorization'] = 'Bearer $token';
      
      request.fields['title'] = lesson.title;
      request.fields['content'] = lesson.content.toString();
      request.fields['duration'] = lesson.duration.toString();
      request.fields['is_demo'] = lesson.isDemo.toString();
      request.fields['course'] = lesson.courseId.toString();
      request.fields['order'] = lesson.order.toString();

      if (videoFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          filename: basename(videoFile.path),
        ));
      }

      var response = await request.send();
      if (response.statusCode == 201) {        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> fetchLessonsByCourse(int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$lessonsUrl/?course=$courseId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("data")) {
          final List<dynamic> lessonData = responseData["data"];
          _lessons = lessonData.map((lesson) => Lesson.fromJson(lesson)).toList();
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to fetch lessons");
      }
    } catch (e) {
      throw Exception("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
