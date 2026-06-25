import 'dart:typed_data';

import '../models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<String> uploadAvatar(Uint8List bytes, String userId, String extension);
}
