import '../../models/booking.dart';
import '../../services/supabase_service.dart';
import '../booking_repository.dart';

class SupabaseBookingRepository implements BookingRepository {
  const SupabaseBookingRepository(this.service);

  final SupabaseService service;

  @override
  Future<List<Booking>> getBookings() async {
    final data = await service.client
        .from('bookings')
        .select()
        .order('scheduled_at', ascending: false);
    return data.map<Booking>((json) => Booking.fromJson(json)).toList();
  }

  @override
  Future<Booking> createBooking(Booking booking) async {
    final data = await service.client
        .from('bookings')
        .insert(booking.toJson())
        .select()
        .single();
    return Booking.fromJson(data);
  }
}
