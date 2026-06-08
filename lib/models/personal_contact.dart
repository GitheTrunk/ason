class PersonalContact {
  const PersonalContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.relationship,
  });

  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? relationship;

  factory PersonalContact.fromJson(Map<String, dynamic> json) {
    return PersonalContact(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'phone': phone,
        if (relationship != null) 'relationship': relationship,
      };

  PersonalContact copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? relationship,
  }) {
    return PersonalContact(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
    );
  }
}
