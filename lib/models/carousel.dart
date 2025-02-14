class Carousel {
  int? id;
  String title;
  String? image;
  String? modifiedOn;

  Carousel({
    this.id,
    required this.title,
    this.image,
    this.modifiedOn,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      modifiedOn: json['modified_on'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'modified_on': modifiedOn,
    };
  }
}
