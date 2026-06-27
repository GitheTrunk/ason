class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.address,
    this.phone,
    this.importantInfo,
    this.bloodGroup,
    this.allergies,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? name;
  final String? address;
  final String? phone;
  final String? importantInfo;
  final String? bloodGroup;
  final String? allergies;
  final String? avatarUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      importantInfo: json['important_info'] as String?,
      bloodGroup: json['blood_group'] as String?,
      allergies: json['allergies'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (name != null) 'name': name,
    if (address != null) 'address': address,
    if (phone != null) 'phone': phone,
    if (importantInfo != null) 'important_info': importantInfo,
    if (bloodGroup != null) 'blood_group': bloodGroup,
    if (allergies != null) 'allergies': allergies,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
  };

  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? address,
    String? phone,
    String? importantInfo,
    String? bloodGroup,
    String? allergies,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      importantInfo: importantInfo ?? this.importantInfo,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
