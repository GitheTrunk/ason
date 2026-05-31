import 'package:ason/providers/service_providers.dart';
import 'package:ason/repositories/impl/supabase_emergency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/booking_repository.dart';
import '../repositories/emergency_repository.dart';
import '../repositories/promotion_repository.dart';
import '../repositories/review_repository.dart';

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return SupabaseEmergencyRepository(ref.watch(supabaseServiceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  throw UnimplementedError(
    'ReviewRepository implementation is not registered.',
  );
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  throw UnimplementedError(
    'BookingRepository implementation is not registered.',
  );
});

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  throw UnimplementedError(
    'PromotionRepository implementation is not registered.',
  );
});
