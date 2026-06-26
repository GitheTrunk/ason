import 'package:ason/repositories/emergency_repository.dart';
import 'package:ason/repositories/impl/supabase_emergency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService(Supabase.instance.client);
});

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return SupabaseEmergencyRepository(ref.watch(supabaseServiceProvider));
});
