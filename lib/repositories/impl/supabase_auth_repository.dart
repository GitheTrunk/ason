import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/supabase_service.dart';
import '../auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Stream<AuthState> get authStateChanges => _supabaseService.client.auth.onAuthStateChange;

  @override
  User? get currentUser => _supabaseService.client.auth.currentUser;

  @override
  Future<AuthResponse> signUp({
    required String email, 
    required String password,
    String? name,
    String? address,
  }) async {
    final metadata = <String, dynamic>{};
    if (name != null) metadata['name'] = name;
    if (address != null) metadata['address'] = address;
    
    return await _supabaseService.client.auth.signUp(
      email: email,
      password: password,
      data: metadata.isEmpty ? null : metadata,
    );
  }

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> verifyOTP({required String email, required String token}) async {
    return await _supabaseService.client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    );
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _supabaseService.client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  @override
  Future<void> signOut() async {
    await _supabaseService.client.auth.signOut();
  }
}
