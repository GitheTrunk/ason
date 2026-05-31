class EmergencyService {
  const EmergencyService({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String type;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final String? imageUrl;

  factory EmergencyService.fromJson(Map<String, dynamic> json) {
    return EmergencyService(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'image_url': imageUrl,
    };
  }
}
