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

  Future<bool> updateLesson({
    required int lessonId,
    required String title,
    String? content,
    String? duration,
    bool? isDemo,
    required int courseId,
    int? orderIndex,    
    // File? coverImage,
    File? video,
  }) async {
    final url = Uri.parse(lessonUpdateUrl(lessonId));
    final token = await AuthHelper.getToken();

    try {
      var request = http.MultipartRequest("PUT", url);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields['title'] = title;
      request.fields['content'] = content ?? "";
      request.fields['duration'] = duration ?? "";
      request.fields['is_demo'] = isDemo.toString();
      request.fields['course_id'] = courseId.toString();
      request.fields['order'] = orderIndex.toString() ?? "1";

      // if (coverImage != null) {
      //   request.files.add(await http.MultipartFile.fromPath('cover_image', coverImage.path));
      // }
      if (video != null) {
        request.files.add(await http.MultipartFile.fromPath('demo_video', video.path));
      }

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        fetchLessonsByCourse(courseId);  // Refresh course list after updating
        return true;
      } else if (response.statusCode == 401) {      
        bool refreshed = await AuthHelper.refreshToken();
        if (refreshed) {
          return updateLesson(
              lessonId: lessonId,
              courseId: courseId,
              title: title,
              content: content,
              duration: duration,
              isDemo: isDemo,
              orderIndex: orderIndex,              
              video: video,
            );            
          } 
          else {
            return false;
          }
      } else {
        print("Lesson update failed: $responseData");
        return false;
      }
    } catch (error) {
      print("Error updating lesson: $error");
      return false;
    }
  }

  Future<bool> deactivateLesson(int lessonId) async {
    final url = Uri.parse(lessonDeleteUrl(lessonId));
    final token = await AuthHelper.getToken();

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'is_active': false}),  // 🔥 Only sending is_active field
      );
      print('inside delete fun');
      if (response.statusCode == 200) {
        print("Lesson deactivated successfully");
        fetchLessonsByCourse(lessonId);
        return true;
      } else if (response.statusCode == 401) {      
          bool refreshed = await AuthHelper.refreshToken();
          if (refreshed) {
            return deactivateLesson(lessonId);            
          } 
          else {
            return false;
          }
        } else {
        print("Failed to deactivate course: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error deactivating course: $e");
      return false;
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

  Lesson? _lesson;

  Lesson? get lesson => _lesson;

  Future<Lesson?> fetchLessonById(int courseId, int lessonId) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse(lessonByIdUrl(lessonId));
    final token = await AuthHelper.getToken();
  
    try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Lesson.fromJson(data); // Ensure Lesson model has fromJson()
    } else {
      print("Error fetching lesson: ${response.body}");
      return null;
    }
  } catch (error) {
    print("Error fetching lesson: $error");
    return null;
  }
  }
}
