import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_profile.dart';
import '../../services/supabase_service.dart';
import '../profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  const SupabaseProfileRepository(this.service);

  final SupabaseService service;

  @override
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final data = await service.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) return null;
      return UserProfile.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final payload = {
      'name': profile.name,
      'address': profile.address,
      'phone': profile.phone,
      'important_info': profile.importantInfo,
      'avatar_url': profile.avatarUrl,
    };

    final data = await service.client
        .from('profiles')
        .update(payload)
        .eq('id', profile.id)
        .select()
        .single();

    return UserProfile.fromJson(data);
  }

  @override
  Future<String> uploadAvatar(Uint8List bytes, String userId, String extension) async {
    final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$extension';
    
    await service.client.storage.from('avatars').uploadBinary(
      fileName,
      bytes,
      fileOptions: FileOptions(
        cacheControl: '3600',
        upsert: true,
        contentType: 'image/$extension',
      ),
    );
        
    return service.client.storage.from('avatars').getPublicUrl(fileName);
  }
}
