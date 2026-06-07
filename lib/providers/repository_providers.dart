import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/booking_repository.dart';
import '../repositories/emergency_repository.dart';
import '../repositories/impl/supabase_booking_repository.dart';
import '../repositories/impl/supabase_emergency_repository.dart';
import '../repositories/impl/supabase_personal_contact_repository.dart';
import '../repositories/impl/supabase_review_repository.dart';
import '../repositories/personal_contact_repository.dart';
import '../repositories/promotion_repository.dart';
import '../repositories/review_repository.dart';
import 'service_providers.dart';

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return SupabaseEmergencyRepository(ref.watch(supabaseServiceProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return SupabaseBookingRepository(ref.watch(supabaseServiceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return SupabaseReviewRepository(ref.watch(supabaseServiceProvider));
});

final personalContactRepositoryProvider =
    Provider<PersonalContactRepository>((ref) {
  return SupabasePersonalContactRepository(ref.watch(supabaseServiceProvider));
});

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  throw UnimplementedError(
    'PromotionRepository implementation is not registered.',
  );
});
