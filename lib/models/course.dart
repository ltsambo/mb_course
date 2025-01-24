import 'lesson.dart';

class Course {
  final String id, title, coverImage, duration, description, createdBy,lastUpdated;
  final bool isOnSale;
  final double price, salePrice;
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
    required this.isOnSale,
    required this.price,
    required this.salePrice,
    required this.demoVideo,
    required this.lessons,    
  });
}