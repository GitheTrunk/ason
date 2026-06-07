class FirstAidGuide {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final List<String> steps;

  FirstAidGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.steps,
  });

  factory FirstAidGuide.fromJson(Map<String, dynamic> json) {
    return FirstAidGuide(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
    );
  }
}
