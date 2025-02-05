class Lesson {
  final int id;
  final String title;
  final String? content;
  final String? video;
  final int duration;
  final bool isDemo;
  final int order;

  Lesson({
    required this.id,
    required this.title,
    this.content,
    this.video,
    required this.duration,
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
      isDemo: json['is_demo'] == true,
      order: json['order'],
    );
  }
}
