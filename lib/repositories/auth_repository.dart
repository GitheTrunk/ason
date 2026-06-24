import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateChanges;
  User? get currentUser;
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
    String? address,
  });

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  });

  Future<void> updatePassword(String newPassword);

  Future<void> signOut();
}
