import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import '../repositories/booking_repository.dart';
import 'repository_providers.dart';

final bookingsProvider = FutureProvider<List<Booking>>((ref) {
  return ref.watch(bookingRepositoryProvider).getBookings();
});

class BookingsNotifier extends AsyncNotifier<List<Booking>> {
  BookingRepository get _repo => ref.read(bookingRepositoryProvider);

  @override
  Future<List<Booking>> build() =>
      ref.watch(bookingRepositoryProvider).getBookings();

  Future<void> create(Booking booking) async {
    await _repo.createBooking(booking);
    ref.invalidateSelf();
  }
}

final bookingsNotifierProvider =
    AsyncNotifierProvider<BookingsNotifier, List<Booking>>(
  BookingsNotifier.new,
);
