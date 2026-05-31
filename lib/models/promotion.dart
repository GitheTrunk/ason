class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.validUntil,
    required this.isActive,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime validUntil;
  final bool isActive;

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      validUntil: DateTime.parse(json['valid_until'] as String),
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'valid_until': validUntil.toIso8601String(),
      'is_active': isActive,
    };
  }
}
