class EmergencyService {
  const EmergencyService({
    required this.id,
    required this.nameEn,
    required this.nameKm,
    required this.typeEn,
    required this.typeKm,
    required this.addressEn,
    required this.addressKm,
    required this.descriptionEn,
    required this.descriptionKm,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.imageUrl,
  });

  final String id;
  final String nameEn;
  final String nameKm;
  final String typeEn;
  final String typeKm;
  final String addressEn;
  final String addressKm;
  final String descriptionEn;
  final String descriptionKm;
  final String phone;
  final double latitude;
  final double longitude;
  final double rating;
  final String? imageUrl;

  factory EmergencyService.fromJson(Map<String, dynamic> json) {
    return EmergencyService(
      id: json['id']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameKm: json['name_km']?.toString() ?? '',
      typeEn: json['type_en']?.toString() ?? '',
      typeKm: json['type_km']?.toString() ?? '',
      addressEn: json['address_en']?.toString() ?? '',
      addressKm: json['address_km']?.toString() ?? '',
      descriptionEn: json['description_en']?.toString() ?? '',
      descriptionKm: json['description_km']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_km': nameKm,
      'type_en': typeEn,
      'type_km': typeKm,
      'address_en': addressEn,
      'address_km': addressKm,
      'description_en': descriptionEn,
      'description_km': descriptionKm,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'image_url': imageUrl,
    };
  }

  bool _isKh(String lang) => lang == 'km' || lang == 'kh';

  String _localizedValue(String lang, String en, String km) {
    final primary = _isKh(lang) ? km : en;
    final fallback = _isKh(lang) ? en : km;
    return primary.trim().isNotEmpty ? primary : fallback;
  }

  String localizedName(String lang) => _localizedValue(lang, nameEn, nameKm);
  String localizedType(String lang) => _localizedValue(lang, typeEn, typeKm);
  String localizedAddress(String lang) =>
      _localizedValue(lang, addressEn, addressKm);
  String localizedDescription(String lang) =>
      _localizedValue(lang, descriptionEn, descriptionKm);

  String getName(bool isKh) => isKh ? nameKm : nameEn;
  String getType(bool isKh) => isKh ? typeKm : typeEn;
  String getAddress(bool isKh) => isKh ? addressKm : addressEn;
  String getDescription(bool isKh) => isKh ? descriptionKm : descriptionEn;
}
