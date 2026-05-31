class Booking {
  const Booking({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.scheduledAt,
    required this.status,
    this.notes,
  });

  final String id;
  final String serviceId;
  final String userId;
  final DateTime scheduledAt;
  final String status;
  final String? notes;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      userId: json['user_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'user_id': userId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
