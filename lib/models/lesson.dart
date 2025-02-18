class Lesson {
  final int? id;
  final String title;
  final String? content;
  final String? video;
  final int duration;
  final int courseId;
  final bool isDemo;
  final int order;

  Lesson({
    this.id,
    required this.title,
    this.content,
    this.video,
    required this.duration,
    required this.courseId,
    required this.isDemo,
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      video: json['video'], // Can be null
      duration: json['duration'], // Ensure it's an int
      courseId: json['course'],
      isDemo: json['is_demo'] == true,
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'duration': duration,
      'is_demo': isDemo,
      'course': courseId,
      'order': order,
      'video': video,
    };
  }
}


class CourseDropDown {
  final int id;
  final String title;

  CourseDropDown({required this.id, required this.title});
  
  factory CourseDropDown.fromJson(Map<String, dynamic> json) {
    return CourseDropDown(
      id: json['id'],
      title: json['title'],
    );
  }
}