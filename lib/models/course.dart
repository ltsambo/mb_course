import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String coverImage;
  final String duration;
  final String description;
  final String createdBy;
  final String lastUpdated;
  final String price;
  final String demoVideo;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.duration,
    required this.description,
    required this.createdBy,
    required this.lastUpdated,
    required this.price,
    required this.demoVideo,
    required this.lessons,    
  });
}