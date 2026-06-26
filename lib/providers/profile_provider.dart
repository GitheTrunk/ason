import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import 'auth_provider.dart';
import 'repository_providers.dart';


class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return null;
    return ref.watch(profileRepositoryProvider).getProfile(user.id);
  }

  Future<void> updateProfile({
    String? name,
    String? address,
    String? phone,
    String? importantInfo,
    String? avatarUrl,
  }) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    final updated = currentProfile.copyWith(
      name: name,
      address: address,
      phone: phone,
      importantInfo: importantInfo,
      avatarUrl: avatarUrl,
    );
    await ref.read(profileRepositoryProvider).updateProfile(updated);
    ref.invalidateSelf();
  }

  Future<void> uploadAvatar(XFile imageFile) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;
    
    final bytes = await imageFile.readAsBytes();
    String extension = 'png';
    if (imageFile.name.contains('.')) {
      extension = imageFile.name.split('.').last.toLowerCase();
    }
    
    final newUrl = await ref.read(profileRepositoryProvider)
        .uploadAvatar(bytes, currentProfile.id, extension);
    await updateProfile(avatarUrl: newUrl);
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile?>(
  ProfileNotifier.new,
);
