import 'dart:convert';

class FirstAidGuide {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final List<String> steps;
  final String? titleKm;
  final String? categoryKm;
  final List<String> stepsKm;

  FirstAidGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.steps,
    this.titleKm,
    this.categoryKm,
    this.stepsKm = const [],
  });

  factory FirstAidGuide.fromJson(Map<String, dynamic> json) {
    return FirstAidGuide(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
      titleKm: json['title_km']?.toString(),
      categoryKm: json['category_km']?.toString(),
      stepsKm: _parseStepsKm(json['steps_km']),
    );
  }

  String localizedTitle(String lang) =>
      _isKh(lang) ? (titleKm ?? title) : title;

  String localizedCategory(String lang) =>
      _isKh(lang) ? (categoryKm ?? category) : category;

  List<String> localizedSteps(String lang) {
    if (_isKh(lang) && stepsKm.isNotEmpty) {
      return stepsKm;
    }
    return steps;
  }

  static List<String> _parseStepsKm(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((item) => item.toString()).toList();
        }
      } catch (_) {
        return [value];
      }
    }
    return const [];
  }

  static bool _isKh(String lang) => lang == 'km' || lang == 'kh';
}
